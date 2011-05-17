require "spec_helper"

describe User do
  subject { Factory(:user) }

  it { should have_many(:beers) }
  it { should have_many(:breweries) }

  it { should validate_presence_of(:public_token) }
  it { should_not allow_mass_assignment_of(:public_token) }

  it { should validate_presence_of(:private_token) }
  it { should_not allow_mass_assignment_of(:private_token) }
end

describe User, "being created" do
  subject { Factory.build(:user) }

  it "generates a public API token" do
    subject.public_token.should be_nil
    subject.save
    subject.public_token.should_not be_nil
  end

  it "generates a private API token" do
    subject.private_token.should be_nil
    subject.save
    subject.private_token.should_not be_nil
  end
end

describe User, "being updated" do
  subject { Factory(:user) }

  let!(:public_token) { subject.public_token }
  let!(:private_token) { subject.private_token }

  it "does not regenerate public API token" do
    subject.updated_at = Time.now
    subject.save
    subject.public_token.should == public_token
  end

  it "does not regenerate private API token" do
    subject.updated_at = Time.now
    subject.save
    subject.private_token.should == private_token
  end
end

describe User, ".find_by_token" do
  let(:user) { Factory(:user) }

  it "finds a user by public token" do
    User.find_by_token(user.public_token).should == user
  end

  it "finds a user by private token" do
    User.find_by_token(user.private_token).should == user
  end
end
