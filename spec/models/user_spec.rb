require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  it { should have_many(:trips) }
  it { should have_many(:comments) }
  it { should have_many(:authentications) }
  it { should have_one(:sign_in_address) }

  before do
    user.trips << FactoryGirl.build(:trip)
  end

  describe "#facebook_user" do
    it 'should test if the user has authenticated via facebook' do
      user.authentications = []
      user.facebook_user?.should be_false

      user.authentications.build(provider: 'facebook', uid: 1011496368)
      user.save!
      user.facebook_user?.should be_true
    end
  end

  describe "experiences" do
    context "unequal number of experiences" do
      it "should return an array of experiences" do
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'positive')
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'negative')
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'neutral')
        user.experiences.should == ['positive', 'negative', 'neutral']
        user.experiences_in_percentage.should == {'positive' => 0.33, 'neutral' => 0.33, 'negative' => 0.33}
      end
    end

    context "only positive experiences" do
      it do
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'positive')
        user.experiences_in_percentage.should == {'positive' => 1.0}
      end
    end
  end

  describe "gender" do 
    it "should display percentage of genders of people who picked you up" do
      user.trips[0].rides << FactoryGirl.build(:ride, :gender => 'male')
      user.trips[0].rides << FactoryGirl.build(:ride, :gender => 'female')
      user.trips[0].rides << FactoryGirl.build(:ride, :gender => 'mixed')
      user.genders.should == ['male', 'female', 'mixed']
      user.genders_in_percentage.should == {'male' => 0.33, 'female' => 0.33, 'mixed' => 0.33}
    end

    it "only male driver" do
      user.trips[0].rides << FactoryGirl.build(:ride, :gender => 'male')
      user.genders_in_percentage.should == {'male' => 1.0}
    end
  end
  
  describe "hitchhiked kms" do
    it "should return total amount of kms hitchhiked" do
      user.trips.first.distance = 100_000
      user.hitchhiked_kms.should == 100
    end
  end

  describe "hitchhiked countries" do
    it "should return number of countries hitchhiked" do
      pending('too slow')
      user.trips.first.from = "Berlin"
      user.trips.first.to   = "Amsterdam"
      user.save!
      user.hitchhiked_countries.should == 2
    end
  end

  describe "geocode" do
    before do
      pending ('too slow')
      user.current_sign_in_ip = "24.193.83.1"
      user.save!
    end

    it "should geocode ip" do
      user.sign_in_lat.should == 40.728
      user.sign_in_lng.should == -73.9453
    end

    it "should geocode address" do
      user.sign_in_address.city.should == "Brooklyn"
      user.sign_in_address.country.should == "United States"
      user.sign_in_address.country_code.should == "US"
    end

    it "should change the address when the ip changes" do
      user.current_sign_in_ip = "85.183.206.162"
      user.save!
      user.sign_in_address.city.should == "Hamburg"
    end
  end
end
