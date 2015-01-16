exports.assertion = (selector, expected, msg) ->

  @message = msg or "Selected text of element<#{selector}> is '#{expected}'"

  @expected = expected

  @pass = (value) ->
    value is expected

  @value = (result) ->
    console.log result.value
    result.value

  @command = (callback) ->
    @client.api.execute(
      getSelectedText, [selector], callback)

  @


#====================================================
# SUBROUTINES
#====================================================
getSelectedText = (selector) ->
  input = $(selector)?.first()?[0]

  if not input
    return null

  # IE
  if document.selection
    return document.selection.createRange().text

  # Mozilla
  input.value.substring(input.selectionStart, input.selectionEnd)
#====================================================