require 'benchmark'

require 'scad4r/runner'
require 'scad4r/notification'
require 'scad4r/result_parser'

require 'guard'
require 'guard/guard'

module Guard
  class Openscad < Guard

    attr_reader :runner
    def initialize(watches=[], options = {})
      super

      net_options = {all_on_start: true,
                     benchmark: true,

                     runner: Scad4r::Runner,
                     result_parser: Scad4r::ResultParser,
                     format: :stl,

                     notifier: Notifier,
                     notification_parser: Scad4r::Notification}.merge(options)

      # Behaviour options
      @all_on_start        = net_options.fetch(:all_on_start)
      @benchmark           = net_options.fetch(:benchmark)

      @runner              = build_runner(net_options)

      @notifier            = net_options.fetch(:notifier)
      @notification_parser = net_options.fetch(:notification_parser)

      @failed              = false
    end

    def start
      run_all if all_on_start?
    end

    def run_all
      run_on_changes(all_watched_files)
    end

   def run_on_changes(paths)
     failed = false

     run_list(paths).each do |path|
       result = process(path)

       if result.has_key?(:error) || result.has_key?(:warning)
         failed = true
       end

       notifications = parse_results(result)
       notifications.each { |notification| notify(notification) }
     end

     if failed
       throw :task_has_failed
     end
   end

    private
    attr_reader :notifier, :notification_parser

    def build_runner(options)
      result_parser = options.fetch(:result_parser).new
      format        = options.fetch(:format)
      runner_class  = options.fetch(:runner)

      runner_class.new(parser: result_parser,
                       format: format)
    end

    def process(path)
      result = nil
      benchmark("Processing #{path}") do
        result = runner.run(path)
      end
      result
    end

    def notify(notification)
      benchmark("Sending Notification") do
        notifier.notify(notification.message,
                       title: notification.title,
                       image: notification.image,
                       priority: notification.priority)
        UI.info([notification.title,notification.message].join(' '))
      end
    end

    def parse_results(result)
      notification = nil
      benchmark("Parsing Results") do
        notification = notification_parser.parse(result)
      end
      notification
    end

    def benchmark(message,&block)
      if @benchmark
        UI.info(message + " " + Benchmark.measure(&block).to_s)
      else
        block.call
      end
    end

    def run_list(paths)
      Array(paths)
    end

    def all_on_start?
      @all_on_start
    end

    def all_watched_files
      Watcher.match_files(self,Dir.glob('{,**/}*{,.*}').uniq)
    end
  end
end
