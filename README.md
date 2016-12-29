# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


##  spec/support/vcr_cassettes_description_with_recorded_request_hint.rb

### Before

```
  1) dummy controller via http requests /a calling n=1 to n=9, but skip n=5 and call n=x after n=6
     Failure/Error: client.get('/dummy/c?n=x') # Fail

     VCR::Errors::UnhandledHTTPRequestError:


       ================================================================================
       An HTTP request has been made that VCR does not know how to handle:
         GET http://0.0.0.0:3010/dummy/c?n=x

       VCR is currently using the following cassette:
         - /Users/ice/fs/rails5-vcr-sandbox/spec/fixtures/vcr_cassettes/features/dummy/1.yml
           - :record => :none
           - :match_requests_on => [:method, :uri]

       Under the current configuration VCR can not find a suitable HTTP interaction
       to replay and is prevented from recording new requests. There are a few ways
       you can deal with this:

         * If you're surprised VCR is raising this error
           and want insight about how VCR attempted to handle the request,
           you can use the debug_logger configuration option to log more details [1].
         * You can use the :new_episodes record mode to allow VCR to
           record this new request to the existing cassette [2].
         * If you want VCR to ignore this request (and others like it), you can
           set an `ignore_request` callback [3].
         * The current record mode (:none) does not allow requests to be recorded. You
           can temporarily change the record mode to :once, delete the cassette file
           and re-run your tests to allow the cassette to be recorded with this request [4].
         * The cassette contains 4 HTTP interactions that have not been
           played back. If your request is non-deterministic, you may need to
           change your :match_requests_on cassette option to be more lenient
           or use a custom request matcher to allow it to match [5].

       [1] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/configuration/debug-logging
       [2] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/record-modes/new-episodes
       [3] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/configuration/ignore-request
       [4] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/record-modes/none
       [5] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/request-matching
       ================================================================================
     # ./spec/features/dummy_spec.rb:51:in `block (4 levels) in <top (required)>'
     # ./spec/features/dummy_spec.rb:43:in `block (3 levels) in <top (required)>'
```

### After

```
  1) dummy controller via http requests /a calling n=1 to n=9, but skip n=5 and call n=x after n=6
     Failure/Error: client.get('/dummy/c?n=x') # Fail

     VCR::Errors::UnhandledHTTPRequestError:


       ================================================================================
       An HTTP request has been made that VCR does not know how to handle:
         GET http://0.0.0.0:3010/dummy/c?n=x

       Current cassette used following recorded requests:
          1.  GET http://0.0.0.0:3010/dummy/a?n=1
          2.  GET http://0.0.0.0:3010/dummy/b?n=2
          3.  GET http://0.0.0.0:3010/dummy/c?n=3
          4.  GET http://0.0.0.0:3010/dummy/a?n=4
          6.  GET http://0.0.0.0:3010/dummy/c?n=6

       Current cassette remains following recorded requests:
          5.  GET http://0.0.0.0:3010/dummy/b?n=5
          7.  GET http://0.0.0.0:3010/dummy/a?n=7
          8.  GET http://0.0.0.0:3010/dummy/b?n=8
          9.  GET http://0.0.0.0:3010/dummy/c?n=9

       Current cassette's recorded requests:
          1. [x]  GET http://0.0.0.0:3010/dummy/a?n=1
          2. [x]  GET http://0.0.0.0:3010/dummy/b?n=2
          3. [x]  GET http://0.0.0.0:3010/dummy/c?n=3
          4. [x]  GET http://0.0.0.0:3010/dummy/a?n=4
          5. [ ]  GET http://0.0.0.0:3010/dummy/b?n=5
          6. [x]  GET http://0.0.0.0:3010/dummy/c?n=6
          7. [ ]  GET http://0.0.0.0:3010/dummy/a?n=7
          8. [ ]  GET http://0.0.0.0:3010/dummy/b?n=8
          9. [ ]  GET http://0.0.0.0:3010/dummy/c?n=9

       VCR is currently using the following cassette:
         - /Users/ice/fs/rails5-vcr-sandbox/spec/fixtures/vcr_cassettes/features/dummy/1.yml
           - :record => :none
           - :match_requests_on => [:method, :uri]

       Under the current configuration VCR can not find a suitable HTTP interaction
       to replay and is prevented from recording new requests. There are a few ways
       you can deal with this:

         * If you're surprised VCR is raising this error
           and want insight about how VCR attempted to handle the request,
           you can use the debug_logger configuration option to log more details [1].
         * You can use the :new_episodes record mode to allow VCR to
           record this new request to the existing cassette [2].
         * If you want VCR to ignore this request (and others like it), you can
           set an `ignore_request` callback [3].
         * The current record mode (:none) does not allow requests to be recorded. You
           can temporarily change the record mode to :once, delete the cassette file
           and re-run your tests to allow the cassette to be recorded with this request [4].
         * The cassette contains 4 HTTP interactions that have not been
           played back. If your request is non-deterministic, you may need to
           change your :match_requests_on cassette option to be more lenient
           or use a custom request matcher to allow it to match [5].

       [1] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/configuration/debug-logging
       [2] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/record-modes/new-episodes
       [3] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/configuration/ignore-request
       [4] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/record-modes/none
       [5] https://www.relishapp.com/vcr/vcr/v/3-0-3/docs/request-matching
       ================================================================================
     # ./spec/features/dummy_spec.rb:51:in `block (4 levels) in <top (required)>'
     # ./spec/features/dummy_spec.rb:43:in `block (3 levels) in <top (required)>'
```
