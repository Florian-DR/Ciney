require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

# Shrine.storages = {
#   cache: Shrine::Storage::FileSystem.new("public", prefix: "tmp/uploads/cache"), # temporary
#   store: Shrine::Storage::FileSystem.new("public", prefix: "tmp/uploads"),       # permanent
# }

s3_options = {
  access_key_id:     ENV['AWS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region:            ENV['AWS_REGION'],
  bucket:            ENV['AWS_BUCKET'],
}
Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options), # temporary storage
  store: Shrine::Storage::S3.new(prefix: "store", **s3_options), # permanent storage
}

Shrine.plugin :activerecord # or :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation_helpers 