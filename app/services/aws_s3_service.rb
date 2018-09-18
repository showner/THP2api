require 'aws-sdk-s3'

class AwsS3Service
  # attr_reader

  def initialize
    Aws.config.update(access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
                      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
                      region: Rails.application.credentials.dig(:aws, :region) )
  end

  def call(params)
    # binding.pry
    signer = Aws::S3::Presigner.new
    signer.presigned_url(:put_object,
                         bucket: params[:bucket],
                         key: params[:key],
                         acl: params[:acl],
                         content_type: params[:content_type])
  end
end
