require_relative "json_with_metadata_formatter"

class Victim < ActiveResource::Base
  self.element_name = "victim"
  self.collection_name = "victims"
  self.format = JsonWithMetadataFormatter.new
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
end
