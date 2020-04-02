# Quick start

This script was made to quickly export all videos in a given folder of a [Vimeo](https://vimeo.com/) account.

A Pro account or higher is required to access videos MP4 via the API. 

This is only made to download YOUR own files, not anyone else files.

This script is made with [Ruby](https://www.ruby-lang.org/) language and uses [concurrent-ruby](https://github.com/ruby-concurrency/concurrent-ruby) to download 25 files at a time. 

## How to export your videos

The script will export the largest MP4 available for each video and dump a JSON of each
video API payload to be used later if needed (keeps the description and etc).

1 - Get an API access token from your account 

To do this, you muste create an application for use with your own account and generate a personnal
access token at ex. https://developer.vimeo.com/apps/169949#personal_access_tokens

Make sure you choose `Authenticated (you)` and check `Private` and `Video Files`.

2 - Get the folder ID from the URL on vimeo.com 

3 - Install dependencies

    bundle install

4 - Run the export script

    VIMEO_CLIENT_TOKEN=insert_your_token_here EXPORT_PATH=/here/export bundle exec rake download_folder\[insert_video_id_here\]
