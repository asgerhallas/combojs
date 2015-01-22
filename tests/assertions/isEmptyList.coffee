exports.assertion = (selector, msg) ->
  @message = msg or "<#{selector}> should be the empty list"

  @expected = yes

  @pass = (value) -> value is @expected

  @value = (result) -> result.value

  @command = (callback) ->
    @client.api
      .assert.numberOfChildren(selector + "li", 1)
      .assert.innerHTML(selector + "li", "(ingen valgmuligheder)")
  @
