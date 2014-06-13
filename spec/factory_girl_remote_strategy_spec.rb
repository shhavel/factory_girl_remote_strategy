require "spec_helper"

describe FactoryGirl::RemoteStrategy do
  # - FactoryGirl.remote(:incident) builds incident and registers get url with FakeWeb;
  # - remote associations are added to response json:
  #     FactoryGirl.remote(:incident, victims: FactoryGirl.remote_list(:victim, 2))
  # - also allows to create has_many association with <assotiation(s)>_ids option:
  #     FactoryGirl.remote(:incident, victim_ids: [2, 3])
  # - belongs_to association id is added to response json:
  #     FactoryGirl.remote(:membership, group: group) # group_id is added to serialized hash
  # - after(:remote) callback in factories.
  describe "basic usage" do
    it "builds instance and registers get url with FakeWeb" do
      FactoryGirl.remote(:incident, id: 1)
      expect { Incident.find(1) }.not_to raise_error
      incident = Incident.find(1)
      incident.should be_kind_of Incident
    end
  end

  describe "Associations in JSON response" do
    let(:victims) { FactoryGirl.remote_list(:victim, 2) }
    let(:group) { FactoryGirl.remote(:group) }

    it "remote associations are added to response json" do
      FactoryGirl.remote(:incident, id: 3, victims: victims)
      incident = Incident.find(3)
      incident.victims.should be_kind_of Array
      incident.victims.first.should be_kind_of Victim
    end

    it "allows to create has_many association with <assotiation(s)>_ids option" do
      FactoryGirl.remote(:incident, id: 4, victim_ids: [2, 3])
      incident = Incident.find(4)
      incident.victims.should be_kind_of Array
      incident.victims.first.should be_kind_of Victim

      expect { Victim.find(2) }.not_to raise_error
      victim = Victim.find(2)
      victim.should eq incident.victims.first
    end

    it "belongs_to association id is added to response json" do
      membership = FactoryGirl.remote(:membership, group: group)
      membership.group_id.should == group.id
    end
  end

  describe "after(:remote) callback in factories" do
    it "invokes after(:remote) callback" do
      incident = FactoryGirl.remote(:incident, reported_by: 4)
      expect { User.find(4) }.not_to raise_error
      user = User.find(4)
      user.should be_kind_of User
    end
  end

  describe "FactoryGirl.remote_search" do
    it "registers search url with FakeWeb" do
      remote_search FactoryGirl.remote_list(:membership, 2), search: { premises_id_in: [4] }
      expect { Membership.find(:all, params: { search: { premises_id_in: [4] } }) }.not_to raise_error
      memberships = Membership.find(:all, params: { search: { premises_id_in: [4] } }).to_a
      memberships.should be_kind_of Array
      memberships.first.should be_kind_of Membership
    end

    it "registers search url of empty collection if provided model class (no first element)" do
      remote_search Membership, search: { premises_id_in: [4] }
      expect { Membership.find(:all, params: { search: { premises_id_in: [4] } }) }.not_to raise_error
      memberships = Membership.find(:all, params: { search: { premises_id_in: [4] } }).to_a
      memberships.should eq []
    end
  end

  describe "Search by primary_key" do
    context "primary_key is id" do
      let!(:user) { remote(:user, id: 4) }

      it "registers search url for equality <primary_key>_eq = <value>" do
        expect { User.find(:first, params: { search: { id_eq: 4 } }) }.not_to raise_error
        user = User.find(:first, params: { search: { id_eq: 4 } })
        user.id.should == 4
      end

      it "registers search url for inclusion <primary_key>_in [<value>]" do
        expect { User.find(:first, params: { search: { id_in: [4] } }) }.not_to raise_error
        user = User.find(:first, params: { search: { id_in: [4] } })
        user.id.should == 4
      end
    end

    context "custom primary_key" do
      let!(:postcode) { remote(:postcode, code: 'ABCD') }

      it "registers search url for equality <primary_key>_eq = <value>" do
        expect { Postcode.find(:first, params: { search: { code_eq: 'ABCD' } }) }.not_to raise_error
        postcode = Postcode.find(:first, params: { search: { code_eq: 'ABCD' } })
        postcode.code.should == 'ABCD'
      end

      it "registers search url for inclusion <primary_key>_in [<value>]" do
        expect { Postcode.find(:first, params: { search: { code_in: ['ABCD'] } }) }.not_to raise_error
        postcode = Postcode.find(:first, params: { search: { code_in: ['ABCD'] } })
        postcode.code.should == 'ABCD'
      end
    end
  end

  context "custom primary_key" do
    it "builds instance and registers get url with FakeWeb" do
      FactoryGirl.remote(:postcode, code: 'FGH')
      expect { Postcode.find('FGH') }.not_to raise_error
      postcode = Postcode.find('FGH')
      postcode.should be_kind_of Postcode
      postcode.code.should == 'FGH'
    end
  end
end
