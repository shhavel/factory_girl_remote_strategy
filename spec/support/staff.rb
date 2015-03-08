class Staff < ActiveResource::Base
  self.format = :json
  self.include_root_in_json = true 
  self.site = "http://example.com"
  self.prefix = "/api/v1/"
  self.element_name = "staff"
  self.collection_name = "staff"
end
