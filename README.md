# Template ui/api app structure for quickly going from idea to startup

A slightly opinionated template for getting you to your mvp as fast as possible!!!

## Project structure

This project uses docker for development has two main components:

  - `ui` - A *typescript-react* app that powers the front-end for the app.
  - `api` - A *rails* api-only app that powers the back-end for the app.

The `api` component is supported by a postgresql docker instance. There is an `nginx` reverse proxy thats acts as an edge server between the developer's machine and these docker containers.

Features
 1. React with typescript
 2. Rails 7 api mode backend
 3. `ruby 3.1.0` 
 4. `nodejs 16.13.0`
 5. Docker for development
 6. Postgresql for persistence
 7. Secret management with rails encrypted credentials
 8. Sideqik for asynchronous jobs
 9. Circle CI config (coming soon)
 10. Kubernetes for container orchestration (coming soon)
 11. AWS for deployment (coming soon)

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
                                            └────.│.───────┘        └──────────────┘
                                                 .│.
                                                 .│.
                                                 .│.
                                                 .│.
                                            ┌────.│.───────┐        ┌──────────────┐
                                            │              │        │              │
                                            │              │        │              │
                                            │    sidekiq   ├────────►    redis     │
                                            │              │        │              │
                                            │              │        │              │
                                            └──────────────┘        └──────────────┘
```

## Development

### 4-step Quick start developement
  1. `git clone <git url for your repo created from this template> && cd <your dir>`
  2. `echo "RAILS_MASTER_KEY=$(hexdump -vn16 -e'4/4 "%08X" 1 "\n"' /dev/urandom)" > .env`
  3. `docker-compose up -d`
  4. `docker exec api bundle exec rails db:create db:migrate`

Then visit http://localhost:5000

### Starting the servers for development
  1. Install `docker` if required. https://www.docker.com/
  2. Create three 32-bit hex codes randomly and make note of them in a secure place. This is your master keys for all your environments so avoid committing this into your github.
       - One for development env. This is to be shared with every developer in your team.
       - One for test env. This is to be shared with every developer in your team.
       - One for production env. This is to be shared with members with production access only.
  2. Create `.env` file in the project root and add `RAILS_MASTER_KEY=development key from step 2`.
  3. Run `docker-compose up`. Add `-d` option to run in detached mode.
  4. Run `docker exec api bundle exec rails db:create db:migrate`
  5. http://localhost:5000

### Installing new gems in `api/`
  1. Add new gem to `Gemfile`
  2. Run `docker exec api bundle install`. *All new changes to the `Gemfile.lock` file must be committed to git*

### Creating new migrations in `api/`
  1. Run `docker exec api bundle exec rails new migration <name of migration>`
  2. Run `docker exec api bundle exec rails db:migrate`. *All new changes to the `schema.rb` file must be committed to git*

### Running tests in `api/`
  1. Run `docker exec api bundle exec rails test`
  2. Alternatively use the `./shell` executable in `api` to enter the container's bash shell to run individual tests

### Adding new npm packages in `ui/`
  1. Add new package to `package.json`
  2. Run `docker exec ui npm install`. *All new changes to the `package-lock.json` file must be committed to git*

### Running tests in `ui/`
  1. Run `docker exec ui npm run test`
  2. Alternatively use the `./shell` in `ui` executable to enter the container's bash shell to run individual tests

### Credentials/Secret management
  
  #### A Note about credentials 
  In `api` Rails 7 app - There are two important keys by default:

  1. Master key: This is used to encrypt a file called `api/config/credentials.yml.enc`. This file stores an encrypts version of every secret you want to use in your rails app in a particular environment. This should never be committed to your version control. By default at runtime Rails checks for the value of this master in key in the following order:
      1. `ENV["RAILS_MASTER_KEY"]`
      2. `config/master.key` file
  
  2. Secret Key Base: This key the default secret key that comes up with a fresh rails app. This is used to sign and encrypt session cookies. By default in development Rails randomly generates one on the fly and stores it in `api/tmp/development_secret.txt`. In other environments - In all other environments, we look for it the following order:
      1. `ENV["SECRET_KEY_BASE"]`
      2. `Rails.application.credentials.secret_key_base` This is from the `config/credentials.yml.enc`. The location of this file can vary in different environments. You can commit this file to git or vcs without any worries - even for production as long as master key remains secure.
      3. `Rails.application.secrets.secret_key_base` This is basically for backwards compatibility with older rails versions. This comes from when we stores secrets in `secrets.yml` files. For most applications, the correct place to store it is in the encrypted credentials file. The location of the secrets file varies in different environment.

  So if you want to add any other secrets you can just simple add a new key into the `yml.enc` file using rails binaries. This is the recommended practice. Read [this](https://guides.rubyonrails.org/security.html#session-storage) for more info...

  For other environment file precendence orders, Read [this](https://github.com/rails/rails/blob/09a2979f75c51afb797dd60261a8930f84144af8/railties/lib/rails/application.rb#L432)

  The advantage of this is that the secrets can also be version controlled but better management.

  #### How to add credentials to any environment

  1. Copy the master key pertaining to your environment into your clipboard.
  2. Run `api/shell` to enter the shell for api container.
  3. Run `RAILS_ENV=<master key of the environment> bundle exec rails credentials:edit --environment <developent|test|production>`. The `--environment` flag is important for best practices.
  4. This opens up a nano instance with a `.yml` file loaded add any secrets to the file and save. This creates an `<env>.yml.enc` if its doesnt exist and saves your credentials there. If it does exists it modifies the file.
  5. Access this secret in your code using `Rails.application.credentials.<key>`.
  6. Make sure you commit any `<env>.yml.enc` you generate or mutate. This is encrypted by your master key so it should be safe as long as your master key is not compromised.
  7. If your master key is compromised then you must rotate every credential in your `<env>.yml.enc` file.
  8. To deploy secrets in production make sure to commit `production.yml.enc` into your vcs before deploying the code version. As long as its the correct key it should be decrypted at runtime in production.
