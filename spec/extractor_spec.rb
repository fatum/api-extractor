require 'spec_helper'

describe "Api" do
  it "should work" do
    get '/'

    last_response.should be_ok
  end
end
