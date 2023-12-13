require 'rails_helper'
require 'byebug'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "validate presence of required fields" do
      should validate_presence_of(:title)
      should validate_presence_of(:content)
      should validate_presence_of(:user_id)
    end
  end
end
