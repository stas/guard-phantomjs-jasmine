/**
 * Jasmine JSON Console Reporter
 * Uses console.log to output JSONified Jasmine results
 */
(function(window, console) {
  /**
   * Console Reporter constructor
   */
  var ConsoleReporter = function() {};

  /**
   * Reporter prototype
   */
  ConsoleReporter.prototype = {
    /**
     * Instance storage for result details
     */
    results: {
      started: (new Date()).getTime(),
      ended: null,
      total: 0,
      passed: 0,
      suites: []
    },

    /**
     * Is called when runner is done.
     * Outputs the stringified `results` value
     * Ends with the exit code.
     */
    reportRunnerResults: function() {
      this.results.ended = (new Date()).getTime();
      var return_code = 0;

      if ( this.results.total - this.results.passed !== 0 ) {
        return_code = 1;
      }

      console.log( JSON.stringify(this.results) );
      console.log('EXIT ' + return_code);
    },

    /**
     * Is called when a spec is processed
     * Stores all the details in `results` attribute
     */
    reportSpecResults: function( spec ) {
      var spec_result, items;

      this.results.total++;

      if (spec.results().passed()) {
        this.results.passed++;
      }

      spec_result = {
        desc: spec.suite.parentSuite ? spec.suite.parentSuite.description : '',
        name: spec.suite.description,
        spec: spec.description,
        passed: spec.results().passed(),
        trace: null
      };

      items = spec.results().getItems()
      spec_result.trace = items[0].trace.message || items[0].trace;

      this.results.suites.push( spec_result );
    }

  };

  // Exposes Console Reporter class
  window.ConsoleReporter = ConsoleReporter;
})(window, console);
