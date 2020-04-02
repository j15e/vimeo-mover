require 'byebug'
require_relative 'lib/vimeo_mover'

desc "Get source videos in folder"
task :download_folder, [:folder_id] do |t, args|
  VimeoMover.new(args.folder_id, ENV["VIMEO_CLIENT_TOKEN"], ENV["EXPORT_PATH"]).download
end
