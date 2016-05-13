###Slicer

Export an order and its dependencies from the console:
```ruby
order = Order.find(1234)
Slicer.export(order)
=> 'Export saved to /your/rails/root/test/data/slicer/order_1234.yml'
```

That export can then be used in a test:
``` ruby
require 'test_helper'
class OrdersControllerTest < ActionController::TestCase
	test "should get order 1234" do
	  assert Slicer.import('order_1234')
	  get :show, :id => 1234
	  assert_response :success
	end
end
```