exports.assertion = (command, reporter) ->

  @time = -1

  @message = "Time assertion failed"

  @expected = 0

  @pass = (value) -> 0 is 0

  @value = (result) -> 0

  @command = (callback) =>
    @client.api.time(command, (time) =>
      report = reporter(time)
      @message = report
      callback()
    )
  @