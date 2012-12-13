# DeferrableActions

A very simple way to defer a controller action, and execute it in
another request.

## Installation

Add this line to your application's Gemfile:

    gem 'deferrable_actions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deferrable_actions

## Usage

Include the module 'DefferrableActions' in the controller that you want
to defer actions, if you want, you can include the module in the
ApplicationController and all your controllers are going to have the
ability to defer actions.

```ruby
class ApplicationController < ActionController::Base
  include DeferrableActions
  
  # other stuff ...
end
```

## Example

The principal way that we use deferrable actions, is to defer actions
that need to authenticate the user in the middle of a POST request,
because we can't can redirect to a POST.

We use it like this:

```ruby
class TripsController < ApplicationController
  def create
    @trip = Trip.new(params[:trip])

    if @trip.save
      defer! :publish_trip!, trip_id: @trip.id
      redirect_to auth_path
    else
      render :new
    end
  end
end

class SessionsController < ApplicationController
  def create
    # something ....

    if defered_action?
      execute_defered_action!
    else
      redirect_to root_url
    end
  end

  def failure
    if defered_action?
      on_failure_execute_defered_action!
    else
      redirect_to root_url
    end
  end

  private

  def publish_trip!(args)
    trip = Trip.find(args[:trip_id])
    trip.publish_by! current_user

    redirect_to trip
  end

  def on_failure_publish_trip!(args)
    redirect_to trip_failed_path(args[:trip_id])
  end
end
```

## People

* Benito Serna @bhserna
* Jorge Gajón @gajon

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
