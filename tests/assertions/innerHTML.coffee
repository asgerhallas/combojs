exports.assertion = (selector, expected, msg) ->
  ###
  The message which will be used in the test output and
  inside the XML reports
  @type {string}
  ###
  @message = msg or "element content matches #{expected}"

  ###
  A value to perform the assertion on. If a function is
  defined, its result will be used.
  @type {function|*}
  ###
  @expected = expected

  ###
  The method which performs the actual assertion. It is
  called with the result of the value method as the argument.
  @type {function}
  ###
  @pass = (value) -> value is expected


  ###
  The method which returns the value to be used on the
  assertion. It is called with the result of the command's
  callback as argument.
  @type {function}
  ###
  @value = (result) -> result.value



  ###
  Performs a protocol command/action and its result is
  passed to the value method via the callback argument.
  @type {function}
  ###
  @command = (callback) ->
    @client.api.execute(
      (selector) -> $(selector).html(),
      [selector],
      callback
    )

  @