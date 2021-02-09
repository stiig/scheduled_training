# README

### Initial setup the project
Prepare env variables
```
cp .env.template .env
```
Change `.env` with your credentials and run:
```ruby
bundle install
bundle exec rails db:setup
```

### Tests
For running tests:
```bash
bundle exec rspec
```
