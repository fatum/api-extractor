require 'spec_helper'

describe Extractor do
  it "should work" do
    with_api(Extractor) do
      get_request(path: '/api/v1/extractor') do |r|
        r.response.should == '[:response, "ok"]'
      end
    end
  end
end
