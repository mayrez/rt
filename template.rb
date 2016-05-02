
#generate("rspec")
generate("cucumber")
gem 'faker'

## setup for the win
inside ('spec') { 
  run "mkdir exemplars"
  run "rm -rf fixtures"
  run "rm spec_helper.rb spec.opts rcov.opts"
  run "curl -sL http://github.com/imajes/rails-template/raw/master/spec_helper.rb > spec_helper.rb"
  run "curl -sL http://github.com/imajes/rails-template/raw/master/rcov.opts > rcov.opts"
  run "curl -sL http://github.com/imajes/rails-template/raw/master/spec.opts > spec.opts"
  
}

## Potentially Useful 
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git'
plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'

## user related
if yes?("Will this app have authenticated users?")
  plugin 'role_requirement', :git => 'git://github.com/timcharper/role_requirement.git'
  plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
  plugin 'aasm', :git => 'git://github.com/rubyist/aasm.git'
  gem 'ruby-openid', :lib => 'openid'  
  generate("authenticated", "user session")
  generate("roles", "Role User")
end

if yes?("OpenID Support?")
  plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
  rake('open_id_authentication:db:create')
end

# tags
if yes?("Do you want tags with that?")
  plugin 'acts_as_taggable_redux', :git => 'git://github.com/geemus/acts_as_taggable_redux.git'
  rake('acts_as_taggable:db:create')
end

# require some gems
if yes?("Want to require a bunch of useful gems?")
  gem 'hpricot', :source => 'http://code.whytheluckystiff.net'
  gem 'RedCloth', :lib => 'redcloth'
end

# Final install steps
rake('gems:install', :sudo => true)
rake('db:sessions:create')
rake('db:migrate')

first = ask("What'll be your first action?")
generate(:model, first)

# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'First POST!'"

# Success!
puts "SUCCESS! - remember to setup hoptoad with the following:"
puts "HoptoadNotifier.configure do |config|
  config.api_key = '1234567890abcdef'
end"