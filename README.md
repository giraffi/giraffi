# The Giraffi Ruby Gem

A Ruby wrapper for the Giraffi API

## Installation

    gem install giraffi

## Requirements
* Ruby 1.9.2 or later
* An apikey for the Giraffi API

## Usage

### How to start monitoring your web site status via HTTP

1. Create a new Giraffi::Client object
2. Create a medium
3. Create an axion
4. Add the medium you created to the axion
5. Create an item
6. Add a service to the item
7. Add a trigger to the service
8. Update the axion of the trigger
9. Update the region of the service
10. Reload the settings

``` ruby
require 'json'
require 'pp'

# An `APIKEY` that allows you to access the Giraffi API
APIKEY = 'hanamoguella'

# Sample attributes to create a `medium`
medium_attrs = {
  name: "Alert Email",
  mediumtype: "email",
  options: { address: "user@example.com" }
}

# Sample attributes to create an `axion`
axion_attrs = {
  name: "aborted alert",
  axiontype: "messaging",
  options: {}
}

# Sample attributes to create an `item`
item_attrs = {
  name: "web01",
  host: "localhost",
  ip: "127.0.0.1",
  normalinterval: 120,
  warninginterval: 60,
  warningretry: 2,
  status: 1
}

# Sample attributes to create a `service`
service_attrs = {
  servicetype: "web_response_time",
  normalinterval: 120,
  warninginterval: 60,
  warningretry: 2,
  status: 1,
  options: {}
}

# Sample attributes to create a `trigger`
trigger_attrs = {
  triggertype: "timeout",
  axioninterval: 180,
  options:{
    time: "3"
  }
}

# Create a Giraffi client object
g = Giraffi.new({apikey: APIKEY})

# Create a medium
response = g.create_medium(medium_attrs)
medium_id = JSON.parse(response.body)['medium']['id']

# Create an axion
response = g.create_axion(axion_attrs)
axion_id = JSON.parse(response.body)['axion']['id']

# Add the medium you created to the axion
pp g.add_medium_to_axion(axion_id, medium_id)

# Create an item
response = g.create_item(item_attrs)
item_id = JSON.parse(response.body)['item']['id']

# Add a service to the item
response = g.add_service_to_item(item_id, service_attrs)
service_id = JSON.parse(response.body)['service']['id']

# Add a trigger to the service
response = g.add_trigger_to_service(service_id, trigger_attrs)
trigger_id = JSON.parse(response.body)['trigger']['id']

# Update the axion of the trigger
pp g.update_axion_of_trigger(trigger_id, axion_id, "problem")

# Update the region of the service
pp g.update_region_of_service(service_id, "JP")

# Reload the settings
pp g.reload_items

```
