## Good Night Server (Rails API)

A simple sleep-tracking API with social following and a feed of friends’ sleep records.

### Features
- **Sleep tracking**: `clock_in` and `clock_out`, with computed `duration_s`.
- **Social graph**: follow/unfollow users.
- **Feeds**: fetch recent completed sleep sessions from people you follow, paginated.
- **Serialization & validation**: `active_model_serializers`, `dry-validation`.
- **Pagination**: via `kaminari`.

### Tech stack
- **Runtime**: Ruby 3.2.2, Rails 7.1
- **DB**: PostgreSQL (UUID PKs using `pgcrypto`)
- **Server**: Puma
- **Gems**: `active_model_serializers`, `dry-validation`, `kaminari`
- **Testing**: RSpec, FactoryBot, Faker, Shoulda Matchers
- **Container**: Multi-stage Dockerfile

### Prerequisites
- Ruby 3.2.2 and Bundler
- PostgreSQL 13+

## Getting started

### 1) Install
```bash
git clone <your-repo-url>
cd good-night-server
bundle install
```

### 2) Configure environment
Set `DATABASE_URL` (or edit `config/database.yml`).
```bash
export DATABASE_URL="postgres://localhost:5432/good_night_dev"
```

### 3) Database
```bash
bin/rails db:create
bin/rails db:migrate
```

### 4) Run server
```bash
bin/rails server
# http://localhost:3000
```

### 5) Test
```bash
bundle exec rspec
```

## API reference

Base path: `/api/v1`

- **Health**
  - GET `/up` → 200 OK if the app boots

- **Sleep records**
  - POST `/api/v1/sleep_records/clock_in/:user_id`
  - POST `/api/v1/sleep_records/clock_out/:user_id`

- **Follows**
  - POST `/api/v1/follows` — body: `{ "follower_id": "<uuid>", "followed_id": "<uuid>" }`
  - DELETE `/api/v1/follows` — body: `{ "follower_id": "<uuid>", "followed_id": "<uuid>" }`

- **Feeds**
  - GET `/api/v1/feeds/:user_id?{page,per_page}`
  - Returns recent completed sleep sessions from followed users with pagination metadata.

Example:
```bash
curl "http://localhost:3000/api/v1/feeds/<user_id>?page=1&per_page=10"
```

## Data model

- `users` — id: uuid, `name`
- `sleep_records` — id: uuid, `user_id`, `clock_in`, `clock_out`, `duration_s`, timestamps
  - Scopes: `active`, `order_by_created_at`, `order_by_duration`, `from_week_ago`, `clock_out_not_nil`
- `follows` — id: uuid, `follower_id`, `followed_id`

### Key indexes
- Partial/composite index for completed records ordered by duration within a time range:
  - `[:user_id, :duration_s, :created_at]` with `WHERE clock_out IS NOT NULL AND duration_s IS NOT NULL`
- Unique partial index enforcing one active record per user: `WHERE clock_out IS NULL`

## Services
- `sleep_record_service.rb`: clock in/out business logic
- `follow_service.rb`: follow/unfollow
- `feed_service.rb`: builds the feed with pagination

## Development tips
- `bin/rails c` console, `bin/rails s` server
- `dotenv-rails` available for local env vars
- Pagination via `kaminari` (`page`, `per_page`)
