require 'spec_helper'

describe SectionsController do
  render_views

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should contain
    end
  end

end
