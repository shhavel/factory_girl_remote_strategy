require_relative "json_with_metadata_formatter"

class User < ActiveResource::Base
  self.element_name = "user"
  self.collection_name = "users"
  self.format = JsonWithMetadataFormatter.new
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
end
