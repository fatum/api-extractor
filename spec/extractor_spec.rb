require 'spec_helper'

describe Extractor do
  let(:url) { "http://techcrunch.com/2012/07/22/startup-life-in-indias-organized-chaos/" }

  after(:each) { Content.truncate }

  context "when redirect" do
    it "should successfully parse page" do
      with_api(Extractor) do |api|
        api.config[:http] = { redirects: 3 }

        get_request(path: "/api/v1/extractor?url=http://t.co/kfN4UjwN") do |r|
          output = JSON.parse(r.response)
          output["response"].should_not be_empty
          output["response"]["url"].should == "http://twitter.com/google/status/229576367933648896/photo/1"
        end
      end
    end
  end

  context "without proxy" do
    it "should work" do
      with_api(Extractor) do |api|
        api.config[:http] = {  }

        get_request(path: "/api/v1/extractor?url=#{url}") do |r|
          output = JSON.parse(r.response)
          output["response"].should_not be_empty
          output["response"].keys.map(&:to_sym).should == [:title, :description, :article, :images, :videos, :url]

          output["response"]["images"].should_not be_empty
        end
      end
    end
  end
end
