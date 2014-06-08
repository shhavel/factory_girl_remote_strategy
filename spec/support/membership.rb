require_relative "json_with_metadata_formatter"

class Membership < ActiveResource::Base
  self.element_name = "membership"
  self.collection_name = "memberships"
  self.format = JsonWithMetadataFormatter.new
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
end
