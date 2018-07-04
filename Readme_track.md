# GEMSET?

# Docker REAdme

# Rspec go again


# What it did:

### Create my directory
  
  I've named and moved to my project with `mkdir THP2api && cd THP2api`

### Create new app

First start by watching what options you can use with `rails new --help`: 

The output:
``` 
Usage:
  rails new APP_PATH [options]

Options:
      [--skip-namespace], [--no-skip-namespace]            # Skip namespace (affects only isolated applications)
  -r, [--ruby=PATH]                                        # Path to the Ruby binary of your choice
                                                           # Default: /home/showner/.rvm/rubies/ruby-2.5.1/bin/ruby
  -m, [--template=TEMPLATE]                                # Path to some application template (can be a filesystem path or URL)
  -d, [--database=DATABASE]                                # Preconfigure for selected database (options: mysql/postgresql/sqlite3/oracle/frontbase/ibm_db/sqlserver/jdbcmysql/jdbcsqlite3/jdbcpostgresql/jdbc)
                                                           # Default: sqlite3
      [--skip-yarn], [--no-skip-yarn]                      # Don't use Yarn for managing JavaScript dependencies
      [--skip-gemfile], [--no-skip-gemfile]                # Don't create a Gemfile
  -G, [--skip-git], [--no-skip-git]                        # Skip .gitignore file
      [--skip-keeps], [--no-skip-keeps]                    # Skip source control .keep files
  -M, [--skip-action-mailer], [--no-skip-action-mailer]    # Skip Action Mailer files
  -O, [--skip-active-record], [--no-skip-active-record]    # Skip Active Record files
      [--skip-active-storage], [--no-skip-active-storage]  # Skip Active Storage files
  -P, [--skip-puma], [--no-skip-puma]                      # Skip Puma related files
  -C, [--skip-action-cable], [--no-skip-action-cable]      # Skip Action Cable files
  -S, [--skip-sprockets], [--no-skip-sprockets]            # Skip Sprockets files
      [--skip-spring], [--no-skip-spring]                  # Don't install Spring application preloader
      [--skip-listen], [--no-skip-listen]                  # Don't generate configuration that depends on the listen gem
      [--skip-coffee], [--no-skip-coffee]                  # Don't use CoffeeScript
  -J, [--skip-javascript], [--no-skip-javascript]          # Skip JavaScript files
      [--skip-turbolinks], [--no-skip-turbolinks]          # Skip turbolinks gem
  -T, [--skip-test], [--no-skip-test]                      # Skip test files
      [--skip-system-test], [--no-skip-system-test]        # Skip system test files
      [--skip-bootsnap], [--no-skip-bootsnap]              # Skip bootsnap gem
      [--dev], [--no-dev]                                  # Setup the application with Gemfile pointing to your Rails checkout
      [--edge], [--no-edge]                                # Setup the application with Gemfile pointing to Rails repository
      [--rc=RC]                                            # Path to file containing extra configuration options for rails command
      [--no-rc], [--no-no-rc]                              # Skip loading of extra configuration options from .railsrc file
      [--api], [--no-api]                                  # Preconfigure smaller stack for API only apps
  -B, [--skip-bundle], [--no-skip-bundle]                  # Don't run bundle install
      [--webpack=WEBPACK]                                  # Preconfigure for app-like JavaScript with Webpack (options: react/vue/angular/elm/stimulus)

Runtime options:
  -f, [--force]                    # Overwrite files that already exist
  -p, [--pretend], [--no-pretend]  # Run but do not make any changes
  -q, [--quiet], [--no-quiet]      # Suppress status output
  -s, [--skip], [--no-skip]        # Skip files that already exist

Rails options:
  -h, [--help], [--no-help]        # Show this help message and quit
  -v, [--version], [--no-version]  # Show Rails version number and quit

Description:
    The 'rails new' command creates a new Rails application with a default
    directory structure and configuration at the path you specify.

    You can specify extra command-line arguments to be used every time
    'rails new' runs in the .railsrc configuration file in your home directory.

    Note that the arguments specified in the .railsrc file don't affect the
    defaults values shown above in this help message.

Example:
    rails new ~/Code/Ruby/weblog

    This generates a skeletal Rails installation in ~/Code/Ruby/weblog.
```

Because i don't want to use sprocket, any front-end middleware and the test framework, and also use postgresqlas database: 

`rails new . -T --skip-bundle --api --database=postgresql`

Then rails is generating all required files

You should be able to see all changes with 'git status'

We'll add all to a new commit: `git add .` then `git commit -m '[INITIAL]'`

Push it to github, gitlab or whatever

### Add Rspec

We want to add a framework for tests, i don't want to use Minitest but Rspec:

to do so, add the gem to your `Gemfile` in the `group :development, :test`:

  `gem 'rspec-rails'`


Then to enable it we have to `bundle install`(it should be done everytime you add or remove gems) and install it:

`rails generate rspec:install`

This will create a spec folder with rails_helper and spec_helper, also `.rspec` .
We want to make sure that the `spec_helper` is required in every spec file so add/check this line in `.rspec`:

`--require spec_helper`
`--require rails_helper`

`git add .` changes, and `git commit -m '[ADD] Rspec'` (you could push or not)

### Add Rubocop

To force and help us writing clean code, i'll use Rubocop:

In the `Gemfile` in `group :development` add `gem 'rubocop', '~> 0.54.0', require: false`

New gem added, new `bundle install` required!

Rubocop is a great framework and does great job! And maybe to much

# RUBOCOPSTANDART

run `rubocop`, you might see some offenses. You can correct some of them (perhaps alls) with `rubocop -a`


`git add .` changes, and `git commit -m '[ADD] Rubocop'` && push


### Add husky

We'll add a last tool: `annotate` add `gem 'annotate'` in the Gemfile in development group

You should have `node --version` > 6

Install yarn following [THIS LINK](https://yarnpkg.com/lang/en/docs/install/#debian-stable)

We are able to add husky tool now with: `yarn add husky@next --save-dev`

# PACKAGE.JSON file

### Set uuid as primary key

- REQUIREMENT postgres >= 9.4 & Rails >= 5.1

Following [THIS ARTICLE](https://lab.io/articles/2017/04/13/uuids-rails-5-1/)

so we have to perform:

`rails generate migration enable_pgcrypto_extension`

the migration generated should look like this:
```
class EnablePgcryptoExtension < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'pgcrypto'
  end
end
```

you have to add `enable_extension 'pgcrypto'` in the right line

in `config/application.rb` we add 
```
  config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
  end
```

### Add Factories

add `  gem 'factory_bot_rails'` in the Gemfile in development group


in `spec/rails_helper.rb` add to the config

```
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
```
#### Add faker

add `gem 'faker'` in the Gemfile in development group


# First Things first 

### Requirements

  - Ruby installed
  - Your favorite editor
  - Docker
  - node version > 6
  - github / gitlab account
  - heroku account

You can choose whatever name for the project, we'll use $PROJECT to reference it

### Create the base repository and set it
  
Introducing the workflow we create our repository on [Github](https://github.com/new)(could be the same on [Gitlab](https://gitlab.com/projects/new)).

Lets create the repository with the name you want. I'll pick THP2api this time.

We won't initialize it with a readme because were gonna do it ourself later on.


We will name our project THP2api, to do so we use `mkdir THP2api` and `cd THP2api`  
