require 'spec_helper'
require 'guard/openscad'

module Guard
  module UI

  end

  describe Openscad do

    before do
      UI.stub(:info)
    end

    include RunFilesMatcher

    def di(instance)
      double("DI Faker", new: instance)
    end

    let(:runner) {
      double("Scad Runner", run: run_result) }

    let(:run_result) { {} }

    let(:watches) { [double("Watch")] }
    let(:notifier) { double("Notifier", notify: true) }
    let(:notification_parser) { double("Notification Parser", parse: []) }

    let(:notification) { double("Scad4r::Notification",message: notification_message,
                               title: notification_title,
                               priority: notification_priority,
                               image: notification_image)}

    let(:notification_message) { "a message" }
    let(:notification_title) { "a title" }
    let(:notification_priority) { 2 }
    let(:notification_image) { :error }

    let(:test_mock_options) { { benchmark: false,
                                notifier: notifier,
                                notification_parser: notification_parser } }

    describe ".initialize" do
      context "creating a runner" do

        it "should use the Scad4r::ResultParser by default" do
          Scad4r::Runner.
            should_receive(:new).
            with(hash_including(parser: an_instance_of(Scad4r::ResultParser)))

          described_class.new
        end

        let(:runner_dependency) { Scad4r::Runner }

        it "should pass the format option to the runner" do
          runner_dependency.
            should_receive(:new).
            with(hash_including(format: :csg))

          described_class.new(watches, format: :csg)
        end

        context ":runner option injected" do
          let(:alternate_runner) {
            double("An Alernate Runner Class", new: true) }

          it "should initialize the injected class instead" do
            Scad4r::Runner.should_not_receive(:new)
            alternate_runner.should_receive(:new)

            described_class.new(watches,test_mock_options.merge(runner: alternate_runner))
          end
        end
      end
    end

    describe "#start" do
      it "calls #run_all" do
        subject.should_receive(:run_all)

        subject.start
      end

      context ":all_on_start option is false" do
        subject { described_class.new(watches, test_mock_options.merge(all_on_start: false)) }

        it "doesn't call #run_all" do
          subject.should_not_receive(:run_all)

          subject.start
        end
      end
    end

    describe "#run_all" do
      subject {
        described_class.new(watches, test_mock_options.merge(runner: di(runner))) }

      subject { described_class.new(watches, test_mock_options.merge(
                                    runner: di(runner))) }

      it "should run all scad files which match the watches" do
        Watcher.should_receive(:match_files).
          with(subject,an_instance_of(Array)).
          and_return([:matched_files])

        subject.should_receive(:run_on_changes).with([:matched_files])
        subject.run_all
      end
    end

    describe "#run_on_changes" do
      subject {
        described_class.new(watches, test_mock_options.merge(runner: di(runner))) }

      it "runs with paths" do
        subject.should run_files("scad/cube.scad")

        subject.run_on_changes("scad/cube.scad")

        subject.should run_files(["scad/cube.scad", "scad/jhead.scad"])

        subject.run_on_changes(["scad/cube.scad", "scad/jhead.scad"])
      end

      context "during failure" do
        it "throws :task_has_failed if the results include a warning or error" do
          runner.should_receive(:run).and_return({warning: true, error: true})

          expect { subject.run_on_changes("scad/cube.scad") }.to throw_symbol(:task_has_failed)

          runner.should_receive(:run).and_return({error: true})

          expect { subject.run_on_changes("scad/cube.scad") }.to throw_symbol(:task_has_failed)

          runner.should_receive(:run).and_return({warning: true})

          expect { subject.run_on_changes("scad/cube.scad") }.to throw_symbol(:task_has_failed)

          runner.should_receive(:run).and_return({})

          expect { subject.run_on_changes("scad/cube.scad") }.to_not throw_symbol(:task_has_failed)
        end

        it "keeps failed drawings and rerun them later"
      end

      context "the changed specs pass after failing" do
        it "calls #run_all"

        context ":all_after_pass option is false" do
          it "doesn't call #run_all"
        end
      end

      context "the changed specs pass without failing" do
        it "doesn't call #run_all"
      end

      context "#run_on_changes focus_on_failed" do
        it "switches focus if a single spec changes"
        it "keeps focus if a single spec remains"
        it "keeps focus if random stuff changes"
        it "reruns the tests on the file if keep_failed is true and focused tests pass"
      end
    end

    describe "notifications" do
      subject {
        described_class.new(watches, test_mock_options.merge(runner: di(runner))) }

      context ":notification_parser is a mock" do
        it "should receive parse" do
          notification_parser.should_receive(:parse).with(run_result).and_return([])

          subject.run_on_changes("scad/cube.scad")
        end
      end

      context "default notification_parser" do
        subject {
          described_class.new(watches, test_mock_options.
                              except(:notification_parser).merge(
                                runner: di(runner))) }

        it "should parse with Scad4r::Notification" do
          Scad4r::Notification.should_receive(:parse).with(run_result).and_return([])

          subject.run_on_changes("scad/cube.scad")
        end
      end

      context ":notifier is a mock" do
        it "should notify the notifier" do
          notifier.should_receive(:notify)

          notification_parser.should_receive(:parse).and_return([notification])

          subject.run_on_changes("scad/cube.scad")
        end
      end

      context "default notifier" do
        subject {
          described_class.new(watches, test_mock_options.
                              except(:notifier).merge(
                                runner: di(runner))) }

        it "should notify Guard::Notifier" do
          Notifier.should_receive(:notify)

          notification_parser.should_receive(:parse).and_return([notification])

          subject.run_on_changes("scad/cube.scad")
        end
      end

      context "with notifications" do
        before do
          notification_parser.stub(:parse).and_return([notification])
        end

        after do
          subject.run_on_changes("scad/cube.scad")
        end

        it "should notify with the notification message" do
          notifier.should_receive(:notify).with(notification_message, an_instance_of(Hash))
        end

        it "should notify with the notification title" do
          notifier.should_receive(:notify).with(an_instance_of(String), hash_including(
            title: notification_title))
        end
      end
    end
  end
end
