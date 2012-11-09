if phantom.args.length == 0
  console.log 'Missing mandatory parameter.'
  phantom.exit 1

runner = phantom.args[0]
page = new WebPage()

page.onInitialized = ->
  page.injectJs 'console_json_reporter.js'
  page.evaluate ->
    window.onload = ->
      # If this is an AMD environment, add console reporter using a callback
      if ( window['define'] )
        window.beforeJasmineExecution = ->
          jasmine.getEnv().addReporter( new ConsoleReporter )
      else
        jasmine.getEnv().addReporter( new ConsoleReporter )

page.onConsoleMessage = (msg) ->
  if return_code = msg.match /EXIT (\d)/
    phantom.exit(return_code[1])
  else
    console.log msg

page.open runner, (status) ->
  if status != 'success'
    console.log 'File/URL can not be loaded.'
    phantom.exit 1
