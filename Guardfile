# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', focused_on_failed: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})           { |m| "spec/integration/#{m[1]}_spec.rb" }
  watch("lib/guard/openscad/templates/Guardfile") { |m| "spec/integration" }

  watch('spec/spec_helper.rb')        { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})  { "spec" }
end

