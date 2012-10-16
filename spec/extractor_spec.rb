require 'spec_helper'

describe Extractor do
  let(:url) { "http://techcrunch.com/2012/07/22/startup-life-in-indias-organized-chaos/" }

  after(:each) { Content.truncate }

  context "reproduce yaml parse" do
    it "should successfuly deserealize" do
      with_api(Extractor) do |api|
        -> {
          get_request(path: "/api/v1/extractor?url=http://olympic2012.lenta.ru/news/2012/08/07/_synchro/") do |r|
            row = Content.first
            row.content.should have_key(:title)
          end
        }.should change { Content.count }.from(0).to(1)
      end
    end
  end

  context "when images" do
    it "should successfully parse page" do
      with_api(Extractor) do |api|
        api.config[:http] = { redirects: 3 }

        get_request(path: "/api/v1/extractor?url=http://t.co/5M7IsokL") do |r|
          JSON.parse(r.response).should_not be_empty
        end
      end
    end
  end

  context "when redirect" do
    it "should follow to redirect" do
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
    it "should successfully extract information" do
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
