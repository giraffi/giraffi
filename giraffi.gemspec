# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "giraffi"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["azukiwasher"]
  s.date = "2011-12-09"
  s.description = "A Ruby wrapper for the Giraffi API"
  s.email = "azukiwasher@yahoo.co.jp"
  s.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  s.files = [
    ".document",
    ".yardopts",
    "Gemfile",
    "HISTORY.md",
    "LICENSE.md",
    "README.md",
    "Rakefile",
    "VERSION",
    "examples/setup_http_monitoring.rb",
    "giraffi.gemspec",
    "lib/giraffi.rb",
    "lib/giraffi/client.rb",
    "lib/giraffi/client/applogs.rb",
    "lib/giraffi/client/axions.rb",
    "lib/giraffi/client/items.rb",
    "lib/giraffi/client/logs.rb",
    "lib/giraffi/client/media.rb",
    "lib/giraffi/client/monitoringdata.rb",
    "lib/giraffi/client/my_current_status.rb",
    "lib/giraffi/client/regions.rb",
    "lib/giraffi/client/services.rb",
    "lib/giraffi/client/trends.rb",
    "lib/giraffi/client/triggers.rb",
    "lib/giraffi/config.rb",
    "lib/giraffi/version.rb",
    "test/applogs_test.rb",
    "test/axions_test.rb",
    "test/client_test.rb",
    "test/fixtures/add_applogs_success_response.json",
    "test/fixtures/add_monitroingdata.json",
    "test/fixtures/add_service_to_item.json",
    "test/fixtures/add_trigger_to_service.json",
    "test/fixtures/create_axion.json",
    "test/fixtures/create_item.json",
    "test/fixtures/create_medium.json",
    "test/fixtures/find_applogs_with_no_param.json",
    "test/fixtures/find_applogs_with_params.json",
    "test/fixtures/find_average_trends.json",
    "test/fixtures/find_axion_by_id.json",
    "test/fixtures/find_axion_by_trigger.json",
    "test/fixtures/find_axion_logs_with_no_param.json",
    "test/fixtures/find_axion_logs_with_params.json",
    "test/fixtures/find_axions_by_trigger_with_axionkind.json",
    "test/fixtures/find_axions_by_trigger_without_axionkind.json",
    "test/fixtures/find_axions_with_no_param.json",
    "test/fixtures/find_axions_with_params.json",
    "test/fixtures/find_failure_trends.json",
    "test/fixtures/find_item_by_id.json",
    "test/fixtures/find_items_with_no_param.json",
    "test/fixtures/find_items_with_params.json",
    "test/fixtures/find_media_by_axion.json",
    "test/fixtures/find_media_with_no_param.json",
    "test/fixtures/find_media_with_params.json",
    "test/fixtures/find_medium_by_id.json",
    "test/fixtures/find_monitoringdata_with_no_param.json",
    "test/fixtures/find_monitoringdata_with_params.json",
    "test/fixtures/find_region_by_service.json",
    "test/fixtures/find_regions.json",
    "test/fixtures/find_service_by_id.json",
    "test/fixtures/find_service_by_item_with_params.json",
    "test/fixtures/find_services_by_item_with_no_param.json",
    "test/fixtures/find_services_with_no_param.json",
    "test/fixtures/find_services_with_params.json",
    "test/fixtures/find_trigger_by_id.json",
    "test/fixtures/find_triggers_by_service.json",
    "test/fixtures/find_triggers_with_no_param.json",
    "test/fixtures/find_triggers_with_params.json",
    "test/fixtures/my_current_status_about_fake_uri.json",
    "test/fixtures/my_current_status_about_real_uri.json",
    "test/giraffi_test.rb",
    "test/items_test.rb",
    "test/logs_test.rb",
    "test/media_test.rb",
    "test/monitoringdata_test.rb",
    "test/my_current_status_test.rb",
    "test/regions_test.rb",
    "test/services_test.rb",
    "test/test_helper.rb",
    "test/trends_test.rb",
    "test/triggers_test.rb"
  ]
  s.homepage = "http://github.com/giraffi/giraffi"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "A Ruby wrapper for the Giraffi API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 1.0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.8"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<turn>, [">= 0"])
      s.add_development_dependency(%q<watchr>, [">= 0"])
      s.add_development_dependency(%q<rb-fsevent>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, [">= 1.0"])
      s.add_dependency(%q<httparty>, [">= 0.8"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<turn>, [">= 0"])
      s.add_dependency(%q<watchr>, [">= 0"])
      s.add_dependency(%q<rb-fsevent>, [">= 0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 1.0"])
    s.add_dependency(%q<httparty>, [">= 0.8"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<turn>, [">= 0"])
    s.add_dependency(%q<watchr>, [">= 0"])
    s.add_dependency(%q<rb-fsevent>, [">= 0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

