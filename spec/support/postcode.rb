require_relative "json_with_metadata_formatter"

class Postcode < ActiveResource::Base
  self.element_name = "postcode"
  self.collection_name = "postcodes"
  self.format = JsonWithMetadataFormatter.new
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
  self.primary_key = 'code'
end
