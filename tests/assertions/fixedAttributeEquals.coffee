exports.assertion = (selector, attrId, expected, msg) ->

  # attributeEquals seem to return the wrong value for the spellcheck attribute specifically

  @message = msg or "Attribute[#{attrId}] of element<#{selector}> equals '#{expected}'"

  @expected = expected

  @pass = (value) ->
    value is expected

  @value = (result) ->
    result.value

  @command = (callback) ->
    @client.api.execute(
      getAttribute, [selector, attrId], callback)

  @


#====================================================
# SUBROUTINES
#====================================================
getAttribute = (selector, attrId) ->
  $(selector).attr(attrId)
#====================================================