require 'simplecov-csv'

def isolation_mode?
  ENV.fetch("ISOLATION_MODE",false)
end

def stats_mode?
  ENV.fetch("STATS_MODE", false)
end

module SimpleCov::Formatter
  class MutedHTMLFormatter < HTMLFormatter
    def puts(*args)
    end
  end

  class MutedCSVFormatter < CSVFormatter
    def puts(*args)
    end
  end

  class MutedMergedFormatter
    def format(results)
      [MutedHTMLFormatter, MutedCSVFormatter].each do |formatter|
        formatter.new.format(results)
      end
    end
  end

  class MergedFormatter
    def format(results)
      [HTMLFormatter, CSVFormatter].each do |formatter|
        formatter.new.format(results)
      end
    end
  end
end

if isolation_mode?
  SimpleCov.formatter = SimpleCov::Formatter::MutedCSVFormatter
  SimpleCov.use_merging false
elsif stats_mode?
  SimpleCov.formatter = SimpleCov::Formatter::MutedCSVFormatter
else
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
end

SimpleCov.start do
  add_filter 'bin/'
  add_filter 'features/'
  add_filter 'spec/'

  add_group "Use Cases", "use_cases"
  add_group "Entities", "lib"
end
