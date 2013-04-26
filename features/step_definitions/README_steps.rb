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
  steps %{
    When I successfully run `bundle install` for up to 44 seconds
  }
end

Given /^Setup your Guardfile `([^`]*)`$/ do |command|
  steps %{
    When I successfully run `#{command}` for up to 44 seconds
  }
end

Given /^Run `bundle exec guard`$/ do
  steps %{
    When I run `bundle exec guard` interactively
    And I type "exit"
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

Then /^Guard should notify (?:me|you) with "([^"]*)"$/ do |notification|
  begin
  steps %{
    Then the output should contain "#{notification}"
  }
  rescue ChildProcess::TimeoutError => e
    type("exit")
    retry
  end
end
