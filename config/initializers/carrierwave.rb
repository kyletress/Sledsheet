# config/initializers/carrierwave.rb

# CarrierWave.configure do |config|
#   config.storage    = :aws
#   config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
#   #config.aws_acl    = :'public-read'
#   #config.asset_host = 'http://example.com'
#   #config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365
#
#   config.aws_credentials = {
#     access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
#     secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
#     region:            ENV.fetch('AWS_REGION') # Required
#   }
# end

# CarrierWave.configure do |config|
#   config.aws_credentials = {
#     access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
#     secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
#     region:            ENV.fetch('AWS_REGION')
#   }

#   if Rails.env.test? || Rails.env.development?
#     config.storage = :file
#     #config.enable_processing = false
#     #config.root = "#{Rails.root}/tmp"
#     config.ignore_integrity_errors = false
#     config.ignore_processing_errors = false
#     config.ignore_download_errors = false
#   else
#     config.storage = :aws
#   end

#   config.cache_dir = "#{Rails.root}/tmp/uploads"
#   config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
# end
