require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"
require "image_processing/mini_magick"


s3_options = {
  access_key_id:     ENV['AWS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region:            ENV['AWS_REGION'],
  bucket:            ENV['AWS_BUCKET'],
}
Shrine.storages = {
  cache: Shrine::Storage::S3.new(
    prefix: "cache",
    upload_options: { cache_control: "public, max-age=86400" },
    **s3_options
  ),
  store: Shrine::Storage::S3.new(
    prefix: "store",
    upload_options: { cache_control: "public, max-age=31536000, immutable" },
    **s3_options
  ),
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation_helpers 
Shrine.plugin :pretty_location
Shrine.plugin :determine_mime_type
Shrine.plugin :remote_url, max_size: 20*1024*1024 # 20 MB limit for remote URLs
Shrine.plugin :store_dimensions, analyzer: :mini_magick
Shrine.plugin :derivatives, create_on_promote: true

# Generate responsive WebP files once when an image is promoted to permanent
# storage. The original remains available as a lossless fallback.
Shrine::Attacher.derivatives do |original|
  pipeline = ImageProcessing::MiniMagick
    .source(original)
    .convert("webp")
    .saver(quality: 80, strip: true)

  {
    small: pipeline.resize_to_limit(480, 480).call,
    medium: pipeline.resize_to_limit(960, 960).call,
    large: pipeline.resize_to_limit(1600, 1600).call,
  }
end


# Shrine.plugin :url_options, store: { host: "https://lafermedauwez.be" }
