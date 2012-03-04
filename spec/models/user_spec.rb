# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Basab K. Maulik", email: "bkm.hadoop@gmail.com") }
  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should be_valid }

  context "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  context "when name is greater than 50 characters" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  context "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  context "when email is invalid" do
    invalid_emails = %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_emails.each do |invalid_email|
      before { @user.email = invalid_email }
      it { should_not be_valid }
    end
  end

  context "when email is valid" do
    valid_emails = %w[user@foo.com A_USER@f.b.org first.last@foo.jp a+b@baz.cn]
    valid_emails.each do |valid_email|
      before { @user.email = valid_email }
      it { should be_valid }
    end
  end

  context "when email address is a duplicate" do
    before do
      user_with_dup_email = @user.dup
      user_with_dup_email.save
    end

    it { should_not be_valid }
  end

  context "when email addresses differ only in case" do
    before do
      user_with_upcased_email = @user.dup
      user_with_upcased_email.email = @user.email.upcase
      user_with_upcased_email.save
    end
    it { should_not be_valid }
  end
end
