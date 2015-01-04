exports.assertion = (selector, expected, msg) ->
  @message = msg or "Element <#{selector}> has exactly #{expected} children"

  @expected = expected

  @pass = (value) -> value is expected

  @value = (result) -> result.value

  @command = (callback) ->
    @client.api.execute(
      getNumberOfChildren, [selector], callback)

  @

#====================================================
# SUBROUTINES
#====================================================
getNumberOfChildren = (selector) -> $(selector).length
#====================================================