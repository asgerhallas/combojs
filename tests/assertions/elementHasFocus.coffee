exports.assertion = (selector, msg) ->
  @message = msg or "Element <#{selector}> has focus"

  @expected = yes

  @pass = (value) -> value is @expected

  @value = (result) -> result.value

  @command = (callback) ->
    @client.api.execute(
    	hasFocus, [selector], callback)

  @

#====================================================
# SUBROUTINES
#====================================================
hasFocus = (selector) -> $(selector).is(":focus")
#====================================================