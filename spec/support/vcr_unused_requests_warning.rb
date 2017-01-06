# coding: utf-8

require_relative 'vcr_cassettes_description_with_recorded_request_hint'

module VcrUnusedRequestsWarning
  def self.extended(base)
    class << base
      prepend ClassMethods
    end
  end

  module ClassMethods
    def eject_cassette(options = {})
      if have_unused_cassettes_records?
        warn_unused_cassettes_records
      end

      super
    end

    def have_unused_cassettes_records?
      cassettes.any? { |cassette| cassette.remaining_interactions.size > 0 }
    end

    def unused_cassettes_records_description
      message = ""

      current_example = RSpec.try(:current_example)
      if current_example
        message += "\nCurrent example has unused VCR cassette's records:\n"
        message += "  example path: #{current_example.file_path}\n"
        message += "  example: #{current_example.full_description}\n"
      end

      cassettes.each do |cassette|
        next if cassette.remaining_interactions.size <= 0
        message += "  Cassette: #{cassette.file}\n"
        message += "    - Recorded requests: (recorded_order. actual_order http_metod request_uri)\n"
        message += cassette.description_for_all_interactions.gsub(/^/, '    ')
      end
      unless message.empty?
        message = message.yellow if message.respond_to?(:yellow)
      end

      message
    end

    def warn_unused_cassettes_records
      $stderr.puts unused_cassettes_records_description
    end
  end
end

module VCR
  extend VcrUnusedRequestsWarning
end
