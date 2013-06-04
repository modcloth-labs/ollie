# Ollie

Ollie is a micro-library for building checks that the environment your application runs in is looking ok.  It reports on how the systems your app depends on are performing with more granularity than `everything-is-swell` or `everything-is-failing`.

Here's an example of the kind of output Ollie would generate at `/server-status` when reporting on `git` and `redis`:

```
{
    "git": {
        "revision": "9c2a82a968bfc62d8d5c9fb5a947ec58a43f1560",
        "tag": "deploy",
        "branch": "master",
        "updated_at": "2013-02-14T10:39:31-08:00",
        "errors": []
    },
    "redis": {
        "last_restart": "2013-02-14T10:39:31-08:00",
        "failed_jobs": 0,
        "pending_jobs": 100,
        "errors": []
    }
}
```

Ollie is even more useful when hooked up to an external monitoring system, like Circonus, as it can view trends within the application over time and alert appropriate people when a problem is impending.  You can make Ollie most useful by reporting on numbers over true or false / errors or no-error states.


## Using Ollie with your app

First, include the gem in your `Gemfile`:

```ruby
gem 'ollie', git: 'git@github.com:modcloth-labs/ollie.git'
```

Next, create the controller and route to where you would like Ollie
to perform its checking.  You might call this `StatusController`:

```ruby
class StatusController < ActionController::Base
  include Ollie::Controller
end
```

Ensure routes are setup to route to that controller:

```ruby
Persona::Application.routes.draw do
  get 'server-status', to: 'status#server_status'
  #...
end
```

Finally, indicate what you'd like Ollie to report on:

```ruby
class StatusController < ActionController::Base
  include Ollie::Controller
  report_on :git, :redis
end
```

That's it, Ollie is now setup to report on your app.

## Writing New Checks

Let's walk through writing a check of a log called status.

All checks need to be in the Ollie namespace and be children of Ollie::Base, in `status_logger.rb` so we start with:

```ruby
module Ollie
  class StatusLogger < Ollie::Base
  end
end
```

You indicate which metrics ollie should report on by declaring them with the `metric` class method like this:

```ruby
module Ollie
  class StatusLogger < Ollie::Base
  	metric :file_size
  end
end
```

Declaring a metric is a promise that a method exists with the same name:

```ruby
module Ollie
  class StatusLogger < Ollie::Base
  	metric :file_size
  	
	def file_size
		File.size("status.log")
	end
  end
end
```

If a metric fails it should raise and error.  The error's string representation will be returned in the `errors` key.  In the above example, if the file doesn't exist an error will be raised: `No such file or directory - status.log`

## Adding Checks to Your Controller

To add a check to your controller, use the `report_on` class method:

```ruby
class StatusController < ActionController::Base
  include Ollie::Controller
  report_on :git, :redis, :status_logger
end
```

Make sure that `YourWonderfulCheck` is represented as `your_wonderful_check`

## Author

Ollie was started by [Nick Rowe](mailto:n.rowe@modcloth.com) in February 2013.

--

`How's the weather Ollie?`

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/a75fb0bfb1720e0f05b5483c5fec7828 "githalytics.com")](http://githalytics.com/modcloth/ollie)
