Given /^Add to your `Gemfile`$/ do |string|
  steps %{
    Given a file named "Gemfile" with:
    """
    source "http://rubygems.org"

    #{string}
    """
  }
end

When /^Run `bundle install`$/ do
  unset_bundler_env_vars

  steps %{
    When I successfully run `bundle install` for up to 22 seconds
  }
end

Given /^Setup your Guardfile `guard init`$/ do
  steps %{
    When I run `guard init`
  }
end

Given /^Run `bundle exec guard`$/ do
  steps %{
    When I run `bundle exec guard` interactively
  }
end

When /^You create a new scad file `scad\/cube\.scad`$/ do |string|
  steps %{
    Given a file named "scad/cube.scad" with:
    """
    #{string}
    """
  }
end

Then /^Guard should have processed "(.*?)"$/ do |a_file|
  steps %{
    When The default aruba timeout is 24 seconds
    Then I wait for output to contain "#{a_file}"
  }
end
