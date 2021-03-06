# coding: utf-8

require "danger/request_sources/vsts"

RSpec.describe Danger::RequestSources::VSTS, host: :vsts do
  let(:env) { stub_env }
  let(:subject) { Danger::RequestSources::VSTS.new(stub_ci, env) }

  describe "#new" do
    it "should not raise uninitialized constant error" do
      expect { described_class.new(stub_ci, env) }.not_to raise_error
    end
  end

  describe "#host" do
    it "sets the host specified by `DANGER_VSTS_HOST`" do
      expect(subject.host).to eq("https://example.visualstudio.com/example")
    end
  end

  describe "#validates_as_api_source" do
    it "validates_as_api_source for non empty `DANGER_VSTS_API_TOKEN`" do
      expect(subject.validates_as_api_source?).to be true
    end
  end

  describe "#pr_json" do
    before do
      stub_pull_request
      subject.fetch_details
    end

    it "has a non empty pr_json after `fetch_details`" do
      expect(subject.pr_json).to be_truthy
    end

    describe "#pr_json[:pullRequestId]" do
      it "has fetched the same pull request id as ci_sources's `pull_request_id`" do
        expect(subject.pr_json[:pullRequestId]).to eq(1)
      end
    end

    describe "#pr_json[:title]" do
      it "has fetched the pull requests title" do
        expect(subject.pr_json[:title]).to eq("This is a danger test")
      end
    end
  end
end
