source :rubygems

gem 'rake'
gem 'rspec'
gem 'foodcritic'
gem 'berkshelf'
gem 'thor-foodcritic'
gem 'vagrant', '~> 1.0.6'

group :integration do
  gem 'test-kitchen', :git => "git://github.com/damm/test-kitchen.git", :branch => 'reduce_api_requests'
  gem 'kitchen-vagrant', :git => "git://github.com/opscode/kitchen-vagrant.git"
  gem 'kitchen-ec2', :git => "git://github.com/opscode/kitchen-ec2.git"
  gem 'kitchen-lxc', :git => "https://github.com/portertech/kitchen-lxc.git"
end
