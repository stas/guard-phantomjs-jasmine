require 'guard'
require 'guard/guard'
require 'json'

module Guard
  class PhantomJsJasmine < Guard

    # Initialize Guard::PhantomJsJasmine
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [String] :runner_script, path to the runner script
    # @option options [String] :runner, path to the jasmine runner
    def initialize(watchers = [], options = {})
      super(watchers, options)

      runner_script = 'phantomjs-jasmine/js/jasmine_runner.coffee'
      options[:runner_script] ||= File.expand_path(runner_script, File.dirname(__FILE__))
      options[:runner] ||= File.expand_path('spec/runner.html')
      @options = options
    end

    # Gets called once when Guard starts.
    def start
      ::Guard::UI.info( "#{self.class} is running!" )
    end

    # Gets called when watched paths and files have changes.
    #
    # @param [Array<String>] paths the changed paths and files
    def run_on_change(paths)
      return if paths.empty?

      cmd = "phantomjs #{@options[:runner_script]} #{@options[:runner]}"

      result = IO.popen(cmd)
      parsed_result = JSON.parse(result.read, {
        :max_nesting => false, :symbolize_names => true })
      result.close

      passed = parsed_result[:passed]
      failed = parsed_result[:total] - passed
      run_time = (parsed_result[:ended] - parsed_result[:started]).round(3)

      if failed > 0
        notify("#{failed} Jasmine spec(s) failed.", :failed)
        parsed_result[:suites].each do |suite|
          error("\n#{suite[:name]}\n\t#{suite[:spec]}\n\t\t#{suite[:trace][:message]}") unless suite[:passed]
        end

        info("\n#{failed}/#{parsed_result[:total]} failed in #{run_time} ms.")
      else
        notify("Jasmine specs passed.", :success)
        info("\n#{parsed_result[:total]} passed in #{run_time} ms.")
      end
    end

    private

    # Wrapper against Guard::Notifier#notify
    def notify(message, image)
      ::Guard::Notifier.notify(
        message, :title => 'PhantomJS Jasmine Guard', :image => image)
    end

    # Wrapper against Guard::UI#error
    def error(message)
      ::Guard::UI.error(message)
    end

    # Wrapper against Guard::UI#info
    def info(message)
      ::Guard::UI.info(message)
    end

  end
end
