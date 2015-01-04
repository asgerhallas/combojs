isScrollVerticalVisible = require('./common').isScrollVerticalVisible

exports.assertion = (containerSel, elmSel, msg) ->
  @message = msg or "Element <#{containerSel + elmSel}> is scrollvisible"

  @expected = yes

  @pass = (value) ->
    value is @expected

  @value = (result) ->
    result.value

  @command = (callback) ->
    @client.api.execute(
      isScrollVerticalVisible, [containerSel, elmSel],
      callback)

  @

  