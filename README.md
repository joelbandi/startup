# Template ui/api app structure for quickly going from idea to startup

Can be easily extended with multiple microservices!

## Project structure

This project uses docker for development has two main components:

  - `ui` - A *typescript-react* app that powers the front-end for the app.
  - `api` - A *rails* api-only app that powers the back-end for the app.

The `api` component is supported by a postgresql docker instance. There is an `nginx` reverse proxy thats acts as an edge server between the developer's machine and these docker containers.

Tech Stack
 1. React with typescript
 2. Rails 7 api mode backend
 3. `ruby 3.1.0` 
 4. `nodejs 16.13.0`
 5. Docker for development
 6. Postgresql for persistence
 7. Sideqik for jobs (coming soon)
 8. Circle CI config (coming soon)
 9. AWS for deployment (coming soon)

```
                                            ┌──────────────┐
                                            │              │
                                            │              │
                      ┌───────┐             │     ui       │
                      │       │     ┌───────►              │
                      │       │     │       │              │
┌─────────┐           │       │     │       └──────────────┘
│  local  │           │       │     │
│ machine ├───────────► nginx ├─────┤
│         │           │       │     │
├─────────┤           │       │     │       ┌──────────────┐        ┌──────────────┐
│┼┼┼┼┼┼┼┼┼│           │       │     │       │              │        │              │
└─────────┘           │       │     └───────►              ├────────►              │
                      │       │             │    api       │        │  postgresql  │
                      └───────┘             │              │        │              │
                                            │              │        │              │
                                            └──────────────┘        └──────────────┘
```

## Development

### Starting the servers
  1. Install `docker` if required. https://www.docker.com/
  2. Run `docker-compose up`. Add `-d` option to run in detached mode.
  3. Run `docker exec api bundle exec rails db:create db:migrate`

### Installing new gems in `api/`
  1. Add new gem to `Gemfile`
  2. Run `docker exec api bundle install`. *All new changes to the `Gemfile.lock` file must be committed to git*

### Creating new migrations in `api/`
  1. Run `docker exec api bundle exec rails new migration <name of migration>`
  2. Run `docker exec api bundle exec rails db:migrate`. *All new changes to the `schema.rb` file must be committed to git*

### Running tests in `api/`
  1. Run `docker exec api bundle exec rails test`

### Adding new npm packages in `ui/`
  1. Add new package to `package.json`
  2. Run `docker exec ui npm install`. *All new changes to the `package-lock.json` file must be committed to git*

### Running tests in `ui/`
  1. Run `docker exec ui npm run test`

Alternatively we can also install the runtimes and dependencies locally to machine and run any command directly in local for example; linters and individual tests.
