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
          additional_message += cassettes_description_for_used_interactions(cassette)
          additional_message += cassettes_description_for_remaining_interactions(cassette)
          additional_message += cassettes_description_for_all_interactions(cassette)
        end
        # additional_message += "------------------------------ additional message //\n"
      end

      message = additional_message
      message += super

      message
    end

    def cassettes_description_for_used_interactions(cassette)
      message = "Current cassette used following recorded requests:\n"

      if cassette.used_interactions.blank?
        message += "  - No used recorded interactions\n"
      else
        cassette.used_interactions.each do |interaction|
          i = cassette.all_interactions.index(interaction)
          message += "  %2d. %s\n" % [i + 1, format_interaction(interaction)]
        end
      end

      message + "\n"
    end

    def cassettes_description_for_remaining_interactions(cassette)
      message = "Current cassette remains following recorded requests:\n"

      if cassette.remaining_interactions.blank?
        message += "  - No remaining recorded interactions\n"
      else
        cassette.remaining_interactions.each do |interaction|
          i = cassette.all_interactions.index(interaction)
          message += "  %2d. %s\n" % [i + 1, format_interaction(interaction)]
        end
      end

      message + "\n"
    end

    def cassettes_description_for_all_interactions(cassette)
      message = "Current cassette's recorded requests:\n"

      if cassette.all_interactions.blank?
        message += "  - No recorded interactions\n"
      else
        cassette.all_interactions.each_with_index do |interaction, i|
          sign = cassette.used_interactions.include?(interaction) ? 'x' : ' '
          message += "  %2d. [#{sign}] %s\n" % [i + 1, format_interaction(interaction)]
        end
      end

      message + "\n"
    end

    def format_interaction(interaction)
      http_method = interaction.request.method.upcase
      uri = interaction.request.uri
      "%4s %s" % [http_method, uri]
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
