require 'rubygems'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-system/rake_task'

# We don't want to lint the manifest files used within our tests
exclude_paths = [
  "spec/**/*",
  "vendor/**/*",
  "pkg/**/*"
]

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')

PuppetSyntax.exclude_paths = exclude_paths

