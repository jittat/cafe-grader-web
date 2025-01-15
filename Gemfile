source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

#rails
gem 'rails', '~>5.2'
gem 'activerecord-session_store'
gem 'puma'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#---------------- database ---------------------
#the database
gem 'mysql2'
#for testing
gem 'sqlite3'
gem 'rails-controller-testing'
#for dumping database into yaml
gem 'yaml_db'


#------------- assset pipeline -----------------
# Gems used only for assets and not required
# in production environments by default.
#sass-rails is depricated
#gem 'sass-rails'
gem 'sassc-rails'
gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

gem 'uglifier'

gem 'haml'
gem 'haml-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'


#in-place editor
gem 'best_in_place', '~> 3.0.1'

# jquery addition
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-timepicker-addon-rails'
gem 'jquery-tablesorter'
gem 'jquery-countdown-rails'

#syntax highlighter
gem 'rouge'

#bootstrap add-ons
gem 'bootstrap-sass', '~> 3.4.1'
gem 'bootstrap-switch-rails'
gem 'bootstrap-toggle-rails'
gem 'autoprefixer-rails'
gem 'momentjs-rails'
gem 'rails_bootstrap_sortable'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'jquery-datatables-rails'

#----------- user interface -----------------
gem 'simple_form'
#select 2
gem 'select2-rails'
#ace editor
gem 'ace-rails-ap'
#paginator
gem 'will_paginate', '~> 4.0'

gem 'mail'
gem 'rdiscount'
gem 'dynamic_form'
gem 'in_place_editing'
#gem 'verification', :git => 'https://github.com/sikachu/verification.git'


#---------------- testiing -----------------------
gem 'minitest-reporters'

#---------------- for console --------------------
gem 'fuzzy-string-match'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  #gem 'chromedriver-helper'
  gem 'webdriver'
end

