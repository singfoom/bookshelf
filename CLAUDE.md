# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Installation
- `bin/setup` - Initial setup of the application
- `bundle install` - Install Ruby gems
- `rails db:create` - Create PostgreSQL databases
- `rails db:migrate` - Run database migrations
- `rails db:seed` - Seed the database with initial data

### Development Server
- `bin/dev` - Start the development server (includes asset compilation)
- `rails server` or `rails s` - Start Rails server only
- `bin/jobs` - Start background job processing with Solid Queue

### Testing
- `rails test` - Run the full test suite
- `rails test test/models` - Run model tests only
- `rails test test/controllers` - Run controller tests only
- `rails test test/system` - Run system tests
- `rails test test/integration` - Run integration tests

### Code Quality
- `bin/rubocop` - Run RuboCop linter (uses rails-omakase style guide)
- `bin/rubocop -a` - Auto-fix RuboCop violations where possible
- `bin/brakeman` - Run security vulnerability scanner

### Database Operations
- `rails db:migrate` - Run pending migrations
- `rails db:rollback` - Rollback last migration
- `rails db:reset` - Drop, create, migrate, and seed database
- `rails console` or `rails c` - Start Rails console

## Architecture

### Modern Rails Stack (Rails 8.0)
This is a Rails 8.0 application using the modern defaults:
- **Database**: PostgreSQL with multiple database configuration for production (primary, cache, queue, cable)
- **Asset Pipeline**: Propshaft (modern replacement for Sprockets)
- **JavaScript**: Import maps with Stimulus and Turbo (Hotwire stack)
- **Caching**: Solid Cache (database-backed)
- **Background Jobs**: Solid Queue (database-backed)
- **Real-time**: Solid Cable (database-backed WebSockets)
- **Deployment**: Kamal for containerized deployments

### Key Directories
- `app/models/` - Active Record models
- `app/controllers/` - Controllers handling HTTP requests
- `app/views/` - ERB templates and layouts
- `app/javascript/` - Stimulus controllers and JavaScript modules
- `app/assets/` - CSS and image assets
- `config/` - Application configuration
- `db/` - Database migrations, seeds, and schema files
- `test/` - Test files (Rails uses Minitest by default)

### Database Configuration
- Development: `bookshelf_development`
- Test: `bookshelf_test` 
- Production: Multiple databases for different concerns (primary, cache, queue, cable)

### JavaScript Architecture
- Uses Import Maps for module loading (no Node.js build step required)
- Stimulus controllers in `app/javascript/controllers/`
- Turbo for SPA-like navigation
- Configuration in `config/importmap.rb`

### Production Features
- Docker support with `Dockerfile` and `.dockerignore`
- Kamal deployment configuration in `config/deploy.yml`
- Security scanning with Brakeman
- Performance optimization with Thruster

## Guidelines

### 1. File References in Claude
- Use `@filepath` syntax for file references, not `/file:filepath`
- File references are the preferred way to include content without duplicating it

### 2. Never Overwrite User Configuration
- Always check if CLAUDE.md exists before writing to it
- Use file references to include framework content rather than appending
- Store framework-specific content in separate files (e.g., `.claude-on-rails/context.md`)

### 3. Documentation Clarity
- Clearly distinguish between shell commands and Claude prompts
- Use `>` prefix for Claude prompts to avoid confusion with bash commands
- Be explicit about where commands should be run vs where prompts should be typed

### 4. Ruby Gem Best Practices
- Keep development dependencies in Gemfile, not gemspec (RuboCop rule)
- Always run `bundle exec rake` before committing changes to catch syntax and style issues
- Use `bundle exec rake release` for gem releases (creates tag, pushes to RubyGems)
- ...then create GitHub releases separately with `gh release create`

### 5. Generator Best Practices
- Check for directory existence before creating agents
- Make generators idempotent (running multiple times shouldn't duplicate content)
- Provide clear next steps after generation
- Show what will be created during the analysis phase

## Workflow Guidance

- For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.
- When you're tempted to respond and return control to me with a message like "The codebase is now in excellent shape with 859 passing tests, 1 failing test, and 5 pending tests. The project is ready for the v0.2.0 release once the team decides how to handle the final test (either fix it or mark it as pending)." then instead, you should  decide how to handle the final test _first_.