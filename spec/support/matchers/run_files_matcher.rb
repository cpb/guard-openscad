module RunFilesMatcher
  extend RSpec::Matchers::DSL

  matcher :run_files do |expected_files|
    @expected_files = Array(expected_files)

    match_for_should do |with_running_member|
      if @expected_files.empty?
        fail "Expected #{with_running_member} to run some files, but you provided none."
      else
        @expected_files.each do |expected_file|
          with_running_member.runner.should_receive(:run).with(expected_file)
        end
      end
    end
  end
end
