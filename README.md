# README

* Ruby version
  - V3.3.0


* Database creation
  - rails db:create


* How to run the test suite
  - rails spec


* Steps
  - Make a copy for .env.to_set to .env and set the environment variables
    - Note: iterable io api requests are mocked using https://app.wiremock.cloud/
    - Set ITERABLE_IO_MOCK_URL='https://q947l.wiremockapi.cloud' for mocked response in .env. Below APIs are mocked
       - Track an event: /api/events/track
       - Send Email : /api/email/target
  - bundle install
  - Run rails db:create db:migrate
  - Run rails server
  

* Assumptions:
  - Send an email for Event B task:
    - API request body for sending email need campaignId and it is hardcoded as of now.
    - Email notification is not sent if event B is not created.


* Reference: 
  - https://support.iterable.com/hc/en-us/articles/204780579-API-Overview-and-Sample-Payloads
  - https://api.iterable.com/api/docs#email_target
  - https://api.iterable.com/api/docs#events_track