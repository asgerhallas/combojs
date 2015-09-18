utils = require('../../testutils.js')
utils.plug_macros()

ns = ns_1275
module.exports =

  tags: ["xtz"]

  "setValue twice on same value does not result in repeated itemSelect event": (browser) ->
    # when we need to use this again, let's refactor it into a command and an assertion =)
    browser
      .setupCombo()
      .execute(
        (ns) ->
          document.called = 0
          wrapper = $(ns)

          wrapper
            .on('itemSelect', () ->
              document.called += 1
              console.log "item select", document.called)

          combo = wrapper.data('combo')
          itemId = combo.source[0].id;

          combo.setValue(itemId)
          combo.setValue(itemId)
          return true

        [ns+combo_container]

        (result) -> @assert.ok(utils.checkResult(result), "status ok"))

      .pause(20)

      .execute(
        () -> return document.called

        []

        (result) ->
          @assert.ok(utils.checkResult(result), "status ok")
          @assert.equal(result.value, 1, "callback should only have been called once"))

      .end()
