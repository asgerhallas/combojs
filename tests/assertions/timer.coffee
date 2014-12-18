exports.assertion = (command, reporter) ->
  ###
  The message which will be used in the test output and
  inside the XML reports
  @type {string}
  ###
  @time = -1

  @message = "time assertion failed"

  ###
  A value to perform the assertion on. If a function is
  defined, its result will be used.
  @type {function|*}
  ###
  @expected = 0

  ###
  The method which performs the actual assertion. It is
  called with the result of the value method as the argument.
  @type {function}
  ###
  @pass = (value) -> 0 is 0


  ###
  The method which returns the value to be used on the
  assertion. It is called with the result of the command's
  callback as argument.
  @type {function}
  ###
  @value = (result) -> 0



  ###
  Performs a protocol command/action and its result is
  passed to the value method via the callback argument.
  @type {function}
  ###
  @command = (callback) =>
    @client.api.time(command, (time) =>
      report = reporter(time)
      @message = report
      callback()
    )
  @