require 'json'

module Guard
  # PhantomJS Jasmine command line utils
  #
  module PhantomJsJasmineCli

    # Command line runner
    # Separated from guard so it's possible to be used in rake tasks too
    # @param [Hash] options, to be passed to phantomjs
    #
    def run(options)
      options[:runner] ||= 'spec/runner.html'
      options[:runner_script] ||= File.expand_path(
        'js/jasmine_runner.coffee',
        File.dirname(__FILE__))

      cmd = "phantomjs #{options[:runner_script]} #{options[:runner]}"
      result = IO.popen(cmd)

      begin
        parsed_result = JSON.parse(result.read, {
        :max_nesting => false, :symbolize_names => true })
        result.close
      rescue Exception => exc
        error(exc.message)
        return
      end

      passed = parsed_result[:passed]
      failed = parsed_result[:total] - passed
      run_time = (parsed_result[:ended] - parsed_result[:started]).round(3)

      parsed_result[:suites].each do |suite|
        if suite[:passed]
          info(
            "\n#{suite[:name]}\n\t#{suite[:spec]}"
          )
        else
          error(
            "\n#{suite[:name]}\n\t#{suite[:spec]}\n\t\t#{suite[:trace][:message]}"
          )
        end
      end

      if failed > 0
        notify("#{failed} Jasmine spec(s) failed.", :failed)
        info("\n#{failed}/#{parsed_result[:total]} failed in #{run_time} ms.")
      else
        notify("Jasmine specs passed.", :success)
        info("\n#{parsed_result[:total]} passed in #{run_time} ms.")
      end
    end

    # Helper to output info messages
    # @param [String] msg, the text to output
    def info(msg)
      puts msg
    end

    # Helper to output error messages, colors in red
    # @param [String] msg, the text to output
    def error(msg)
      puts "\e[0;31m#{ msg }\e[0m"
    end

    # Helper to send notifications, not implemented
    # We don't use notify in CLI sessions
    # @param [String] msg, the text to output
    # @param [Symbol] image, the text image
    def notify(msg, image)
    end

  end
end
