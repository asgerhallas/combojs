isScrollVerticalVisible = require('./common').isScrollVerticalVisible

exports.assertion = (containerSel, elmSel, msg) ->
  @message = msg or "Element <#{containerSel + elmSel}> is not scrollvisible"

  @expected = no

  @pass = (value) ->
    value is @expected

  @value = (result) ->
    result.value

  @command = (callback) ->
    @client.api.execute(
      isScrollVerticalVisible, [containerSel, elmSel],
      callback)

  @