require 'spec_helper'

describe User, 'valid' do
  it { should have_many(:hitchhikes) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
end