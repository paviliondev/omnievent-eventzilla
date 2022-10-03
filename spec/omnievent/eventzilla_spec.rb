# frozen_string_literal: true

RSpec.describe OmniEvent::Eventzilla do
  let(:events_json) { File.read(File.join(File.expand_path("..", __dir__), "fixtures", "events.json")) }
  let(:url) { "https://www.eventzillaapi.net" }
  let(:version) { "api/#{OmniEvent::Strategies::Eventzilla::API_VERSION}" }
  let(:path) { "events?offset=0" }

  before do
    OmniEvent::Builder.new do
      provider :eventzilla, { token: "12345" }
    end
  end

  describe "list_events" do
    before do
      stub_request(:get, "#{url}/#{version}/#{path}")
        .with(headers: { "x-api-key" => "12345" })
        .to_return(body: events_json, headers: { "Content-Type" => "application/json" })
    end

    it "returns an event list" do
      events = OmniEvent.list_events(:eventzilla)

      expect(events.size).to eq(2)
      expect(events).to all(be_kind_of(OmniEvent::EventHash))
    end

    it "returns valid events" do
      events = OmniEvent.list_events(:eventzilla)

      expect(events.size).to eq(2)
      expect(events).to all(be_valid)
    end

    it "returns events with metadata" do
      events = OmniEvent.list_events(:eventzilla)

      expect(events.size).to eq(2)
      expect(events.first.metadata.uid).to eq(JSON.parse(events_json)["events"][0]["id"].to_s)
    end
  end
end
