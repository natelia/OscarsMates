# AGENTS.md

This document provides context for AI coding agents working on OscarsMates.

## Project Overview

OscarsMates is a Ruby on Rails social platform for tracking Oscar-nominated films. Users can rate movies (1-10 stars), write reviews, follow friends, compete on rankings, and make Oscar predictions.

## Technology Stack

- **Backend**: Ruby 3.3.6, Rails 7.1.5, SQLite 3, Puma, Sidekiq
- **Frontend**: Hotwired Turbo + Stimulus, Tailwind CSS 3.4, Preline UI, Chart.js
- **JavaScript**: Node.js 22+, Yarn, esbuild, ESLint, Prettier
- **Testing**: RSpec, Factory Bot, Capybara, SimpleCov

## Setup & Environment

All commands run through Docker Compose.

```bash
# Start development server (web + CSS watcher + JS bundler)
docker compose up

# Run a command in the container
docker compose exec web <command>

# Install dependencies
docker compose exec web bundle install
docker compose exec web yarn install

# Database setup
docker compose exec web bin/rails db:create db:migrate
```

## Code Standards

### Ruby

- Ruby 3.3 syntax
- Max line length: 120 characters
- Follow existing RuboCop configuration in `.rubocop.yml`
- Use service objects for complex business logic (`app/services/`)
- Use query objects for database queries (`app/queries/`)

### JavaScript

- Stimulus controllers in `app/javascript/controllers/`
- Follow ESLint configuration in `eslint.config.js`
- Format with Prettier (`.prettierrc`)

### Frontend

- Tailwind CSS for styling
- Preline UI component patterns
- Lucide icons for iconography
- Mobile-responsive design required

## Testing & Quality

```bash
# Run full test suite
docker compose exec web bundle exec rspec

# Run specific tests
docker compose exec web bundle exec rspec spec/models/
docker compose exec web bundle exec rspec spec/services/

# Ruby linting
docker compose exec web bundle exec rubocop
docker compose exec web bundle exec rubocop -a    # Auto-fix

# Security scan
docker compose exec web bundle exec brakeman

# Database consistency check
docker compose exec web bundle exec database_consistency

# JavaScript linting
docker compose exec web yarn lint
docker compose exec web yarn lint:fix

# JavaScript formatting
docker compose exec web yarn format
docker compose exec web yarn prettier --check app/javascript
```

All tests must pass before merging. CI runs: Ruby tests, RuboCop, Brakeman, database consistency, and JavaScript linting.

## Project-Specific Context

### Year Scoping

Most content is scoped by Oscar ceremony year. Routes follow the pattern `/2025/movies`, `/2025/categories`. Always consider year context when working with movies, nominations, reviews, and predictions.

### URL Slugs

Movies use parameterized title slugs instead of numeric IDs. The `to_param` method returns the slug for URL generation.

### Key Patterns

- **Query Objects**: `ListMoviesQuery`, `ListCategoryQuery`, `MatesReviewsQuery` in `app/queries/`
- **Service Objects**: `RankingService`, `UserStatsService`, `UserProgressService` in `app/services/`
- **Stimulus Controllers**: Interactive features (ratings, filtering, charts, avatar upload) in `app/javascript/controllers/`

### Core Models

- `User` - has reviews, favorites, followers/following, avatar (Active Storage)
- `Movie` - has reviews, nominations, categories, genres; uses slugs
- `Review` - user's movie rating (1-10 stars) and watched_on date
- `Nomination` - links movies to categories and years
- `UserPick` - user's Oscar prediction per category per year

### Controllers

- `MoviesController` - movie listing with filtering/sorting
- `UsersController` - profiles, rankings, stats, timeline
- `ReviewsController` - review CRUD
- `CategoriesController` - Oscar category management
- `UserPicksController` - Oscar predictions
- `FavoritesController` - mark/unmark favorites
- `FollowsController` - follow/unfollow users
- `SessionsController` - authentication

### Ranking System

`RankingService` calculates user rankings with:
- Metrics: `films`, `minutes`, `nominations`
- Modes: `goals` (watched vs available), `totals` (watched vs best user)
- Scopes: `mates` (following), `all` (all users)

## Directory Structure

```
app/
├── controllers/     # Request handlers
├── javascript/      # Stimulus controllers
├── models/          # Active Record models
├── queries/         # Query objects
├── services/        # Business logic
└── views/           # ERB templates

spec/
├── controllers/     # Controller tests
├── models/          # Model tests
├── queries/         # Query object tests
├── services/        # Service object tests
├── requests/        # Integration tests
├── system/          # E2E tests with Capybara
└── factories/       # Factory Bot fixtures
```
