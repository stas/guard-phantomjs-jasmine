require 'guard/guard'
require 'guard/ui'
require 'guard/notifier'
require 'guard/phantomjs-jasmine/cli'

module Guard
  class PhantomJsJasmine < Guard
    include PhantomJsJasmineCli

    # Initialize Guard::PhantomJsJasmine
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [String] :runner_script, path to the runner script
    # @option options [String] :runner, path to the jasmine runner
    def initialize(watchers = [], options = {})
      super(watchers, options)

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

      run(@options)
    end

    private

    # Wrapper against Guard::Notifier#notify
    # @param [String] message, the text to output
    # @param [Symbol] image, the text image
    def notify(message, image)
      ::Guard::Notifier.notify(
        message, :title => 'PhantomJS Jasmine Guard', :image => image)
    end

    # Wrapper against Guard::UI#error
    # @param [String] message, the text to output
    def error(message)
      ::Guard::UI.error(message)
    end

    # Wrapper against Guard::UI#info
    # @param [String] message, the text to output
    def info(message)
      ::Guard::UI.info(message)
    end

  end
end
