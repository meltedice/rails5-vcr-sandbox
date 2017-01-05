# coding: utf-8

require 'vcr'

module VcrCassetteInterationsReader
  def self.included(base)
    base.instance_eval do
      prepend InstanceMethods
    end
  end

  module InstanceMethods
    def used_interactions
      http_interactions.instance_variable_get(:@used_interactions).reverse
    end

    def remaining_interactions
      http_interactions.interactions
    end
          
    def all_interactions
      previously_recorded_interactions
    end

    def description_for_used_interactions
      message = ""

      if used_interactions.blank?
        message += "- No used recorded interactions\n"
      else
        used_interactions.each do |interaction|
          i = all_interactions.index(interaction)
          message += "%2d. %s\n" % [i + 1, format_interaction(interaction)]
        end
      end

      message
    end

    def description_for_remaining_interactions
      message = ""

      if remaining_interactions.blank?
        message += "- No remaining recorded interactions\n"
      else
        remaining_interactions.each do |interaction|
          i = all_interactions.index(interaction)
          message += "%2d. %s\n" % [i + 1, format_interaction(interaction)]
        end
      end

      message
    end

    def description_for_all_interactions
      message = ""

      if all_interactions.blank?
        message += "- No recorded interactions\n"
      else
        all_interactions.each_with_index do |interaction, i|
          actual_order = used_interactions.index(interaction)
          actual_order += 1 if actual_order
          message += "%2d. %2s %s\n" % [i + 1, actual_order, format_interaction(interaction)]
        end
      end

      message
    end

    def format_interaction(interaction)
      http_method = interaction.request.method.upcase
      uri = interaction.request.uri
      "%4s %s" % [http_method, uri]
    end

  end
end

module VcrCassettesDescriptionWithRecordedRequestHint
  def self.included(base)
    base.instance_eval do
      prepend InstanceMethods
    end
  end

  module InstanceMethods
    def cassettes_description
      additional_message = ''

      if !current_cassettes.nil? && current_cassettes.size > 0
        # additional_message += "------------------------------ additional message:\n"
        current_cassettes.each do |cassette|
          additional_message += "Cassette: #{cassette.file}\n"
          additional_message += "  - Used following recorded requests:\n"
          additional_message += cassette.description_for_used_interactions.gsub(/^/, '    ')
          additional_message += "  - Remains following recorded requests:\n"
          additional_message += cassette.description_for_remaining_interactions.gsub(/^/, '    ')
          additional_message += "  - Recorded requests: (recorded_order. actual_order http_metod request_uri)\n"
          additional_message += cassette.description_for_all_interactions.gsub(/^/, '    ')
        end
        # additional_message += "------------------------------ additional message //\n"
      end

      message = "#{additional_message}\n"
      message += super

      message
    end
  end
end

module VCR
  class Cassette
    include VcrCassetteInterationsReader
  end

  module Errors
    class UnhandledHTTPRequestError
      include VcrCassettesDescriptionWithRecordedRequestHint
    end
  end
end
