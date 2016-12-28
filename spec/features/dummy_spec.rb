#

require 'rails_helper'

describe "dummy controller via http requests" do
  describe "/a" do
    # rails server -b 0.0.0.0 -p 3010
    let(:client) { Faraday.new(url: 'http://0.0.0.0:3010') }

    example do
      # record: :new_episodes, # :once, :new_episodes, :none, :all
      VCR.use_cassette('features/dummy/1', record: :once) do
        client.get('/dummy/a?n=1')
        client.get('/dummy/b?n=2')
        client.get('/dummy/c?n=3')
        client.get('/dummy/a?n=4')
        client.get('/dummy/b?n=5')
        client.get('/dummy/c?n=6')

        # client.get('/dummy/c?n=x')

        client.get('/dummy/a?n=7')
        client.get('/dummy/b?n=8')
        client.get('/dummy/c?n=9')
      end
    end
  end
end
