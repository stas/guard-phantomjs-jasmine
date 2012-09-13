require 'rake/tasklib'
require 'guard/phantomjs-jasmine/cli'

module Guard

  # Provides a method to define a Rake task that
  # runs the PhatomJS Jasmine specs.
  #
  class PhantomJsJasmineTask < ::Rake::TaskLib
    include ::Guard::PhantomJsJasmineCli

    # Name of the main, top level task
    attr_accessor :name

    # CLI options
    attr_accessor :options

    # Initialize the Rake task
    #
    # @param [Symbol] name the name of the Rake task
    # @param [Hash] options the CLI options
    # @yield [PhantomJsJasmineTask] the task
    #
    def initialize(name = 'jasmine:ci', options = {})
      @name = name
      @options = options

      yield self if block_given?

      namespace :phantomjs do
        desc 'Run all PhantomJS Jasmine specs'
        task(name) do
          begin
            run(self.options)

          rescue SystemExit => e
            case e.status
            when 1
              fail 'Some specs have failed'
            when 2
              fail "The spec couldn't be run: #{ e.message }'"
            end
          end
        end
      end
    end

  end
end
