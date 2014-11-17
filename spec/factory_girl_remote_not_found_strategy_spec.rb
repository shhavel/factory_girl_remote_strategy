require "spec_helper"

describe FactoryGirl::RemoteNotFoundStrategy do
  before { FactoryGirl.remote_not_found(:incident, id: 1) }

  it "registers 404 get url with FakeWeb" do
    expect { Incident.find(1) }.to raise_error ActiveResource::ResourceNotFound
  end

  it "registers search by id as one in array request with empty array" do
    incident = Incident.find(:first, params: { search: { id_in: [1] } })
    expect(incident).to be_nil
  end

  it "registers search by id as exact value request with empty array" do
    incident = Incident.find(:first, params: { search: { id_eq: 1 } })
    expect(incident).to be_nil
  end
end
