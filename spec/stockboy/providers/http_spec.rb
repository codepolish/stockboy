require 'spec_helper'
require 'stockboy/providers/http'

module Stockboy
  describe Providers::HTTP do
    subject(:provider) { Stockboy::Providers::HTTP.new }

    it "should assign parameters from :uri option" do
      provider.uri    = "http://www.example.com/"
      provider.query  = {user: 'u'}
      provider.method = :get

      provider.uri.should    == URI("http://www.example.com/?user=u")
      provider.query.should  == {user: 'u'}
      provider.method.should == :get
    end

    it "should assign parameters from :get" do
      provider.get    = "http://www.example.com/"
      provider.query  = {user: 'u'}

      provider.uri.should    == URI("http://www.example.com/?user=u")
      provider.query.should  == {user: 'u'}
      provider.method.should == :get
    end

    it "should assign parameters from :post" do
      provider.post   = "http://www.example.com/"
      provider.query  = {user: 'u'}

      provider.uri.should    == URI("http://www.example.com/?user=u")
      provider.query.should  == {user: 'u'}
      provider.method.should == :post
    end

    describe ".new" do
      its(:errors) { should be_empty }

      it "accepts block DSL initialization" do
        provider = Providers::HTTP.new do
          get    "http://www.example.com/"
          query  user: 'u'
        end

        provider.uri.should    == URI("http://www.example.com/?user=u")
        provider.query.should  == { user: 'u' }
        provider.method.should == :get
      end
    end

    describe "validation" do
      it "should not be valid without a method" do
        provider.method = nil
        provider.should_not be_valid
        provider.errors.keys.should include(:method)
      end

      it "should not be valid without a uri" do
        provider.uri = ""
        provider.should_not be_valid
        provider.errors.keys.should include(:uri)
      end
    end

    describe "#data" do
      let(:response)   { HTTPI::Response.new(200, {}, '{"success":true}') }

      subject(:provider) do
        Providers::HTTP.new do |s|
          s.uri    = "http://www.example.com/"
          s.query  = {username: "user"}
          s.method = :get
        end
      end

      it "returns string body on success" do
        expect(HTTPI).to receive(:request) { response }

        provider.data.should == '{"success":true}'
      end
    end

    describe "#client" do
      it "yields a generic HTTP interface" do
        provider.client do |http|
          http.should respond_to :get
          http.should respond_to :post
        end
      end
    end

  end
end

