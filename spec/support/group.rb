require_relative "json_with_metadata_formatter"

class Group < ActiveResource::Base
  self.element_name = "group"
  self.collection_name = "groups"
  self.format = JsonWithMetadataFormatter.new
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
end
