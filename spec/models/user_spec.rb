require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  it { should have_many(:trips) }
  it { should have_many(:comments) }
  it { should have_many(:authentications) }
  it { should have_many(:future_trips) }

  describe 'valid?' do
    describe '#username' do
      it 'allows all these letters: /A-Za-z\d_-/' do
        user.username = 'Abc1239_.'
        user.should be_valid
      end

      it 'converts `.` into `_` for facebook usernames' do
        user.username = 'user.name'
        user.save
        user.username.should == 'user_name'
      end

      it 'downcases the user after validation' do
        user.username = 'AlbertHoffmann'
        user.save
        user.username.should == 'alberthoffmann'
      end

      it 'does not allow these letters:' do
        '#$%? '.each_char do |letter|
          user.username = "username#{letter}"
          user.should_not be_valid
        end
      end
    end
  end

  describe "#location_updated_at" do
    it 'should not change if the location does not change' do
      user.save!
      location_updated_at = user.location_updated_at
      user.save!
      user.location_updated_at.should == location_updated_at
    end

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

  describe "#experiences_in_percentage" do
    context "unequal number of experiences" do
      before do
        user.trips << FactoryGirl.build(:trip)
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'positive')
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'extremely positive')
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'neutral')
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'negative')
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'extremely negative')
      end
      it "returns an array of experiences" do
        user.experiences_in_percentage.should == {
          'extremely positive' => 0.2,
          'positive' => 0.2,
          'neutral' => 0.2,
          'negative' => 0.2,
          'extremely negative' => 0.2}
      end

      it 'returns the most positive first' do
        user.sort_experiences.should == ['extremely positive',
                                    'positive',
                                    'neutral',
                                    'negative',
                                    'extremely negative']
      end
    end

    context "only positive experiences" do
      it do
        user.trips << FactoryGirl.build(:trip)
        user.trips[0].rides << FactoryGirl.build(:ride, :experience => 'positive')
        user.experiences_in_percentage.should == {'positive' => 1.0}
      end
    end
  end

  describe "gender" do 
    before { user.trips << FactoryGirl.build(:trip) }
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
    before { user.trips << FactoryGirl.build(:trip) }
    it "should return total amount of kms hitchhiked" do
      user.trips.first.distance = 100_000
      user.hitchhiked_kms.should == 100
    end
  end

  describe "hitchhiked countries" do
    before { user.trips << FactoryGirl.build(:trip) }
    it "should return number of countries hitchhiked" do
      user.trips.first.from = "Berlin"
      user.trips.first.to   = "Amsterdam"
      VCR.use_cassette('hitchhiked_countries') do
        user.save!
      end
      user.hitchhiked_countries.should == 2
    end
  end

  describe "geocode" do
    before do
      VCR.use_cassette('brooklyn') do
        user.current_sign_in_ip = "24.193.83.1"
        user.save!
      end
    end

    it "should geocode lat and lng from ip" do
      user.lat.should == 40.6617
      user.lng.should == -73.9855
    end

    it "should geocode address" do
      user.country_code.should == "US"
      user.city.should == "Brooklyn"
      user.country.should == "United States"
    end
  end

  describe "#formatted_address" do
    it "should display the city name and the country if present" do
      user.city = 'Cairns'
      user.country = 'Australia'
      user.formatted_address.should == 'Cairns, Australia'
    end

    it "should display the country name if present" do
      user.city =    'Cairns'
      user.country = nil
      user.formatted_address.should == 'Cairns'
    end

    it "should display the city name if present" do
      user.city = nil
      user.country = 'Australia'
      user.formatted_address.should == 'Australia'
    end

    it "should display `Unknown` if there is no address" do
      user.city = nil
      user.country = nil
      user.formatted_address.should == 'Unknown'
    end
  end

  describe '#to_geomap' do
    before do
      user.trips << FactoryGirl.build(:trip)
      2.times { user.trips.first.country_distances.build(country: 'Germany', distance: 1000) }
      1.times { user.trips.first.country_distances.build(country: 'Australia', distance: 5000) }
    end

    it 'should return the json for a google chart DataTable' do
      user.to_geomap.should == {'DE' => 2, 'AU' => 5}
    end
  end
end
