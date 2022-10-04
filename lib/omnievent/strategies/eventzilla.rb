# frozen_string_literal: true

require_relative "../../omnievent/eventzilla/version"
require "omnievent/strategies/api"

module OmniEvent
  module Strategies
    # Strategy for listing events from Eventzilla
    class Eventzilla < OmniEvent::Strategies::API
      class Error < StandardError; end

      option :name, "eventzilla"

      API_VERSION = "v2"

      def raw_events
        offset = 0
        response = perform_request(path: request_path(offset))
        events = response["events"]
        retrieved = events.size
        total = response["pagination"][0]["total"]

        while retrieved < total
          offset += 1
          response = perform_request(path: request_path(offset))
          events += response["events"]
          retrieved = events.size
        end

        events
      end

      def event_hash(raw_event)
        data = {
          start_time: get_time(raw_event, "start"),
          end_time: get_time(raw_event, "end"),
          name: raw_event["title"],
          description: raw_event["description"],
          url: raw_event["url"]
        }

        metadata = {
          uid: raw_event["id"].to_s,
          status: convert_status(raw_event["status"])
        }

        metadata[:taxonomies] = raw_event["categories"].split(",") if raw_event["categories"]

        OmniEvent::EventHash.new(
          provider: name,
          data: data,
          metadata: metadata
        )
      end

      def request_url
        "https://www.eventzillaapi.net"
      end

      def request_headers
        { "x-api-key" => options.token }
      end

      def request_path(offset)
        path = "/api/#{API_VERSION}"
        path += "/events"

        query_params = ["offset=#{offset}"]
        path += "?#{query_params.join("&")}"

        path
      end

      def convert_status(raw_status)
        case raw_status
        when "Draft", "Unpublished"
          "draft"
        when "Live", "Completed"
          "published"
        else
          "published"
        end
      end

      def get_time(raw_event, type)
        datetime = raw_event["#{type}_date"]

        if raw_event["#{type}_time"]
          date = raw_event["#{type}_date"].split("T").first
          time = raw_event["#{type}_time"]
          datetime = "#{date}T#{time}"
        end

        datetime += raw_event["utc_offset"] if raw_event["utc_offset"]

        format_time(datetime)
      end
    end
  end
end
