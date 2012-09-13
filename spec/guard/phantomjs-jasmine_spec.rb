require 'spec_helper'

module Guard
  describe PhantomJsJasmine do

    describe "#run_on_change" do

      context "with modifications" do
        let(:mock_results) {
          {
            :passed => 1,
            :total => 1,
            :started => Time.now.to_f,
            :ended => Time.now.to_f,
            :suites => [{
              :name => 'Suite',
              :spec => 'Spec',
              :passed => false,
              :trace => { :message => 'Error Message' }
            }]
          }
        }

        it "executes phantomjs" do
          Notifier.stub(:notify)
          guard = PhantomJsJasmine.new(
            [], :runner => 'spec/run.html',
            :runner_script => 'run.coffee'
          )

          io_mock = mock('IO Connection').as_null_object
          IO.should_receive(:popen).with(
            'phantomjs run.coffee spec/run.html'
          ).and_return(io_mock)

          JSON.should_receive(:parse).and_return(mock_results)

          guard.should_receive(:info)

          guard.run_on_change(['foo'])
        end

        it "notifies on success" do
          io_mock = mock('IO Connection').as_null_object
          io_mock.should_receive(:read).and_return(mock_results.to_json)
          IO.should_receive(:popen).and_return(io_mock)

          Notifier.should_receive(:notify).with('Jasmine specs passed.',
            :title => 'PhantomJS Jasmine Guard', :image => :success)

          subject.should_receive(:info)

          subject.run_on_change(['foo'])
        end

        it "notifies on failures" do
          failed_mock_results = mock_results
          failed_mock_results[:passed] = 0

          io_mock = mock('IO Connection').as_null_object
          io_mock.should_receive(:read).and_return(mock_results.to_json)
          IO.should_receive(:popen).and_return(io_mock)

          subject.should_receive(:error)
          subject.should_receive(:info)

          Notifier.should_receive(:notify).with('1 Jasmine spec(s) failed.',
            :title => 'PhantomJS Jasmine Guard', :image => :failed)

          subject.run_on_change(['foo'])
        end
      end

      context "without modifications" do
        it "skips executing phantomjs" do
          IO.should_not_receive(:popen)
          subject.run_on_change([])
        end
      end

    end

  end
end
