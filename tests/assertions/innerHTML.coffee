exports.assertion = (selector, expected, msg) ->
  @message = msg or "InnerHtml of element <#{selector}> is #{expected}"

  @expected = expected

  @pass = (value) -> value is expected

  @value = (result) -> result.value

  @command = (callback) ->
    @client.api.execute(
      getInnerHtml, [selector], callback)

  @

#====================================================
# SUBROUTINES
#====================================================
getInnerHtml = (selector) -> $(selector).html()
#====================================================