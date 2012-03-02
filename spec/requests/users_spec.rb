require 'spec_helper'

describe "Users" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector 'h3', text: 'Sign Up' }
    it { should have_selector 'title', text: full_title('Sign Up') }
  end
end
