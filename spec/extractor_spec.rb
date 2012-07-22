require 'spec_helper'

describe Extractor do
  let(:url) { "http://techcrunch.com/2012/07/22/startup-life-in-indias-organized-chaos/" }
  it "should work" do
    with_api(Extractor) do
      get_request(path: "/api/v1/extractor?url=#{url}") do |r|
        output = JSON.parse(r.response)
        output["response"].should_not be_empty
        output["response"].keys.map(&:to_sym).should == [:title, :description, :article, :images, :videos]

        output["response"]["images"].should_not be_empty
      end
    end
  end
end
