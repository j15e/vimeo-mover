# frozen_string_literal: true

require "vimeo_me2"
require "down"
require "concurrent"

class VimeoMover
  def initialize(folder_id, client_token, export_path)
    @folder_id = folder_id
    @client = VimeoMe2::VimeoObject.new(client_token)
    @export_path = Pathname.new(export_path)
  end

  def download
    me = @client.get("/me")
    next_videos = "#{me["uri"]}/projects/#{@folder_id}/videos?per_page=25"
    pool = Concurrent::FixedThreadPool.new(25)

    while next_videos
      begin
        videos = @client.get(next_videos)
      rescue VimeoMe2::RequestFailed
        puts "API throttled..."
        sleep 1
        next
      end

      puts "We are at page #{videos["page"]}"
      next_videos = videos.dig("paging", "next")

      tasks = videos["data"].map do |video|
        video_name = video["name"]
        file = video["files"].select { |f| f["type"] == "video/mp4" }.max_by { |f| f["size"] }
        download_url = file["link"]
        base_name = "#{video["uri"].gsub("/", "_")}"
        mp4_path = @export_path.join("#{base_name}.mp4")
        json_path = @export_path.join("#{base_name}.json")

        Concurrent::Future.execute({ executor: pool }) do
          if File.exists?(mp4_path)
            puts "Already downloaded #{video_name}"
          else
            puts "Downloading #{video_name} (#{mp4_path})"
            # Dump video metadata as json for later upload
            File.open(json_path,"w") { |f| f.write(video.to_json) }
            Down.download(download_url, destination: mp4_path)
            puts "Download of #{video_name} completed (#{mp4_path})"
          end
        end
      end

      tasks.map(&:value!)
    end
  end
end
