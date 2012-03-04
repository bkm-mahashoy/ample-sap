# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Basab K. Maulik",
                            email: "bkm.hadoop@gmail.com",
                            password: "test_password",
                            password_confirmation: "test_password") }
  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :authenticate }

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

  context "when password is not present" do
    before { @user.password = @user.password_confirmation = "" }
    it { should_not be_valid }
  end

  context "when password and password_confirmation do not match" do
    before { @user.password_confirmation = "not_test_password" }
    it { should_not be_valid }
  end

  describe "user authentication and the return value of the authenticate method" do
    before { @user.save }
    let(:user_find_by_email) { User.find_by_email(@user.email) }

    context "with valid password" do
      it { should == user_find_by_email.authenticate(@user.password) }
    end

    context "with invalid password" do
      let(:user_for_invalid_password) { user_find_by_email.authenticate("invalid") }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password of less than 6 characters" do
    before { @user.password = "a" * 5 }
    it { should_not be_valid }
  end
end
