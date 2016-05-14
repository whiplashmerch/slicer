#Slicer
Export related records from one environment and import into another

Add to your gemfile:

`gem 'slicer'`

`bundle install`

### Setting up export via Capistrano

1) Create **rake** task
```ruby
#/lib/tasks/slicer.rake

namespace :slicer do
	desc "Export supporting data for an ActiveRecord object"
	task :export => :environment do
		abort "Please specify a MODEL, e.g., MODEL=Order" unless ENV['MODEL']
		abort "Pleaes specify an ID, e.g., ID=1234" unless ENV['ID']
		abort "Unable to locate record" unless obj = ENV['MODEL'].constantize.find(ENV['ID'])
		Slicer.export(obj)
	end
end
```

2) Wrap your rake task in a **cap** task
```ruby
#/lib/capistrano/tasks/slicer.rake

namespace :slicer do
	task :export do
	  on roles(:all) do
	    within release_path do
	      with rails_env: fetch(:rails_env) do
	        execute :rake, "slicer:export MODEL=#{ENV['MODEL']} ID=#{ENV['ID']}"
	        download! "#{release_path}/test/data/slicer/#{ENV['MODEL']}#{ENV['ID']}.yml", "/YOUR/LOCAL/RAILS/ROOT/test/data/slicer"
	      end
	    end 
	  end
	end
end
```

3) You can now create an export in a remote environment and download it one step:
```
$ cap ROLE slicer:export MODEL=Order ID=1234
```

### Importing

Exports can then be used in tests:
``` ruby
require 'test_helper'
class OrdersControllerTest < ActionController::TestCase
	test "should get order 1234" do
	  assert Slicer.import('Order1234')
	  get :show, :id => 1234
	  assert_response :success
	end
end
```

### Console Usage
Exporting can be done directly in the console. This will execute against the console environment's database:
```ruby
Slicer.export( Order.find(1234) )
=> 'Export saved to /your/rails/root/test/data/slicer/Order1234.yml'
```

Imports can be made into the database for your console environment's database
```ruby
Slicer.import( 'Order1234' )
=> true
```
