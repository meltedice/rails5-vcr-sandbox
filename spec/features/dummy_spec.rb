#

require 'rails_helper'

describe "dummy controller via http requests" do
  describe "/a" do
    # rails server -b 0.0.0.0 -p 3010
    let(:client) { Faraday.new(url: 'http://0.0.0.0:3010') }

    example "n=1, 2, 3, 4, ..., 9" do
      # record: :new_episodes, # :once, :new_episodes, :none, :all
      VCR.use_cassette('features/dummy/1', record: :once) do
        client.get('/dummy/a?n=1')
        client.get('/dummy/b?n=2')
        client.get('/dummy/c?n=3')
        client.get('/dummy/a?n=4')
        client.get('/dummy/b?n=5')
        client.get('/dummy/c?n=6')
        client.get('/dummy/a?n=7')
        client.get('/dummy/b?n=8')
        client.get('/dummy/c?n=9')
      end
    end

    example "n=1, 2, 3, 4, <skip 5>, 6, ..., 9" do
      VCR.use_cassette('features/dummy/1', record: :none) do
        client.get('/dummy/a?n=1')
        client.get('/dummy/b?n=2')
        client.get('/dummy/c?n=3')
        client.get('/dummy/a?n=4')
        # client.get('/dummy/b?n=5') # OK
        client.get('/dummy/c?n=6')
        client.get('/dummy/a?n=7')
        client.get('/dummy/b?n=8')
        client.get('/dummy/c?n=9')
      end
    end

    example "n=1, 2, 3, 4, <6>, <5>, ..., 9" do
      VCR.use_cassette('features/dummy/1', record: :none) do
        client.get('/dummy/a?n=1')
        client.get('/dummy/b?n=2')
        client.get('/dummy/c?n=3')
        client.get('/dummy/a?n=4')
        client.get('/dummy/c?n=6') # OK
        client.get('/dummy/b?n=5') # OK
        client.get('/dummy/a?n=7')
        client.get('/dummy/b?n=8')
        client.get('/dummy/c?n=9')
      end
    end

    example "n=1, 2, 3, 4, <skip 5>, 6, <unknown request x causes an error>, 7, 8, 9" do
      expected_part_of_error_message = <<-EOT
  - Used following recorded requests:
     1.  GET http://0.0.0.0:3010/dummy/a?n=1
     2.  GET http://0.0.0.0:3010/dummy/b?n=2
     3.  GET http://0.0.0.0:3010/dummy/c?n=3
     4.  GET http://0.0.0.0:3010/dummy/a?n=4
     6.  GET http://0.0.0.0:3010/dummy/c?n=6
  - Remains following recorded requests:
     5.  GET http://0.0.0.0:3010/dummy/b?n=5
     7.  GET http://0.0.0.0:3010/dummy/a?n=7
     8.  GET http://0.0.0.0:3010/dummy/b?n=8
     9.  GET http://0.0.0.0:3010/dummy/c?n=9
  - Recorded requests: (recorded_order. actual_order http_metod request_uri)
     1.  1  GET http://0.0.0.0:3010/dummy/a?n=1
     2.  2  GET http://0.0.0.0:3010/dummy/b?n=2
     3.  3  GET http://0.0.0.0:3010/dummy/c?n=3
     4.  4  GET http://0.0.0.0:3010/dummy/a?n=4
     5.     GET http://0.0.0.0:3010/dummy/b?n=5
     6.  5  GET http://0.0.0.0:3010/dummy/c?n=6
     7.     GET http://0.0.0.0:3010/dummy/a?n=7
     8.     GET http://0.0.0.0:3010/dummy/b?n=8
     9.     GET http://0.0.0.0:3010/dummy/c?n=9
      EOT

      expect do
        VCR.use_cassette('features/dummy/1', record: :none) do
          client.get('/dummy/a?n=1')
          client.get('/dummy/b?n=2')
          client.get('/dummy/c?n=3')
          client.get('/dummy/a?n=4')
          # client.get('/dummy/b?n=5') # OK
          client.get('/dummy/c?n=6')

          client.get('/dummy/c?n=x') # Fail

          client.get('/dummy/a?n=7')
          client.get('/dummy/b?n=8')
          client.get('/dummy/c?n=9')
        end
      end.to raise_error(VCR::Errors::UnhandledHTTPRequestError, /.*#{Regexp.escape(expected_part_of_error_message)}.*/)
    end

  end
end
