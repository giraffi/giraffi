dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require File.join(dir, 'giraffi')
require 'pp'

# Sample code
giraffi = Giraffi::Client.new({:apikey => 'wtLTFEqCTX55Lvhtzlqw6doj5xuphemxJa707QXtDPc'})
puts "-------------------------------------"
puts "Giraffi Ruby Gem " + Giraffi::Version
puts "-------------------------------------"

# Items
find_items_options = {
   customkey: "26cfa4e2-e493-44d7-8322-4f03b467b412"
}
create_item_options = {
  name: "applog test",
  status: "1"
}
create_item_options = {
  name: "Monitor SmartMachine",
  host: nil,
  ip: "210.152.137.59",
  normalinterval: "300",
  warninginterval: "180",
  warningretry: "5",
  status: "2",
  customkey: "6f76d596-e4c7-4b54-9afb-e2615c42d1aa"
}

create_service_options = {
  servicetype: "applog",
  status: "1"
}
update_item_options = {
  name: "Locus Solus"
}
#pp giraffi.find_items(find_items_options) # with params
#pp giraffi.find_items # witout options
#pp giraffi.find_item(3835)
#pp giraffi.find_services_by_item(3845, {servicetype: "applog"})
#pp giraffi.create_item(create_item_options)
#pp giraffi.reload_items
#pp giraffi.add_service_to_item(4004, create_service_options)
#pp giraffi.update_item(3845, update_item_options)
#pp giraffi.destroy_item(3835)
#pp giraffi.remove_service_from_item(3845, 19838)
#pp giraffi.find_item(3845)

# Services
find_services_options = {
  item_id: "3681"
}
create_service_options = {
  servicetype: "applog",
  status: "1"
}
create_trigger_options = {
  triggertype: "timeout",
  axioninterval: 180,
  options: {
    time: "3"
  }
}
update_service_options = {
  status: "0"
}
#pp giraffi.find_services(find_services_options) # with params
#pp giraffi.find_services # without params
#pp giraffi.find_service(18925)
#pp giraffi.find_region_by_service(17972)
#pp giraffi.find_triggers_by_service(17972)
#pp giraffi.add_trigger_to_service(17972, create_trigger_options)
#pp giraffi.update_service(17972, update_service_options)
#pp giraffi.update_region_by_service(17972, "US") # RESPONSE FORMAT IS NOT JSON
#pp giraffi.destroy_service(18925)
#pp giraffi.remove_trigger_from_service(18799, 1108)

# Media
find_media_options = {
  name: "Tweat",
  mediumtype: "twitter"
}
create_media_options = {
  name: "Tweat",
  mediumtype: "twitter"
}
update_media_options = {
  options: {
    address: "hogehoge@example.com"
  }
}
#pp giraffi.find_media(find_media_options) # with params
#pp giraffi.find_media # without params
#pp giraffi.find_medium(517) # without params
#pp giraffi.find_oauth_by_medium(12345) 
#pp giraffi.find_oauth_callback_by_medium(12345, "")
#pp giraffi.create_medium(create_media_options)
#pp giraffi.update_medium(522, update_media_options) #Could not update?
#pp giraffi.destroy_medium(517)
#pp giraffi.find_media # without params

# Axions
find_axions_options = {
  axtion_type: "http_request"
}
create_axion_options = {
  :name => "Alerting",
  :axiontype => "messaging"
}
update_axion_options = {
   :name => "Post message to the Campfire"
}
#pp giraffi.find_axions(find_axions_options) # with params
#pp giraffi.find_axions # without params
#pp giraffi.find_axion()
#pp giraffi.find_media_by_axion(425)
#pp giraffi.create_axion(create_axion_options)
#pp giraffi.execute_axion(425)
#pp giraffi.update_axion()
#pp giraffi.add_medium_to_axion(425, 522)
#pp giraffi.destroy_axion()
#pp giraffi.remove_medium_from_axion(425, 522)

# Applogs
find_applogs_options = {
  :type => "app"
}
add_applogs_options = {
  :level => "error",
  :type => "app",
  :time => "1323318027.9443982",
  :message => "Internal Server Error 500"
}
#pp giraffi.find_applogs(find_applogs_options) # with params
#pp giraffi.find_applogs # without params
#pp giraffi.add_applogs(add_applogs_options)

# Logs
find_axion_logs_options = {
  axion_id: 425
}
count_axion_logs_options = {
  axion_id: 425
}
#pp giraffi.find_axion_logs(find_axion_logs_options) # with params
#pp giraffi.find_axion_logs # without params
#pp giraffi.count_axion_logs(count_axion_logs_options) # with params
pp giraffi.count_axion_logs # without params

# Monitoringdata
find_monitoringdata_options = {
  service: "19838"
}
add_monitoringdata_options = {
  :service_id => "17972",
  :servicetype => "load_average",
  :value => "20",
  :tags => ["Testing now", "26cfa4e2-e493-44d7-8322-4f03b467b412"],
  :checked_at => "#{Time.now.to_i}"
}
#pp giraffi.find_monitoringdata(find_monitoringdata_options) # with params
#pp giraffi.find_monitoringdata # without params
pp giraffi.add_monitoringdata(add_monitoringdata_options)

# MyCurrentStatus
#pp giraffi.my_current_status('lapi')
#pp giraffi.my_current_status('ghost')
#pp giraffi.my_current_status()

# Regions
#pp giraffi.find_regions

# Trends
find_average_trends_options = {
  service_id: "19838"
}
find_failure_trends_options = {
  service_id: "19838"
}
#giraffi.find_average_trends(find_average_trends_options)
#giraffi.find_failure_trends(find_failure_trends_options)

# Triggers
find_triggers_options = {
  axioninterval: "180",
  view_mode: "include"
}
update_trigger_options = {
  options: {
    time: "12"
  }
}

#pp giraffi.find_triggers(find_triggers_options)
#pp giraffi.find_triggers
#pp giraffi.find_trigger(1150)
#pp giraffi.find_axions_by_trigger(1150)
#pp giraffi.execute_axions_by_trigger("1150")
#pp giraffi.update_trigger(1150, update_trigger_options)
#pp giraffi.update_axion_by_trigger(1150,425,'recovery')
#pp giraffi.destroy_trigger(1)
#pp giraffi.remove_axion_from_trigger(1, 2)
