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
