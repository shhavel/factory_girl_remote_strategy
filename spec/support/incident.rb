require_relative "json_with_metadata_formatter"

class Incident < ActiveResource::Base
  self.element_name = "incident"
  self.collection_name = "incidents"
  self.format = JsonWithMetadataFormatter.new
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
end
