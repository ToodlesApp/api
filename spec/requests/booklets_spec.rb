require 'rails_helper'

RSpec.describe "Booklets", :type => :request do
  describe "GET /booklets" do
    it "works! (now write some real specs)" do
      get booklets_path
      expect(response).to have_http_status(200)
    end
  end
end
