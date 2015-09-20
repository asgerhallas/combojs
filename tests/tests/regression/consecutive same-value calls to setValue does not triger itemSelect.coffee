utils = require('../../testutils.js')
utils.plug_macros()

ns = ns_1275
module.exports =

  tags: ["abc"]

  "consecutive same-value calls to setValue does not triger itemSelect": (browser) ->

    browser
      .setupCombo()

      .execute(
        (ns) ->
          combo = $(ns).data('combo')

          itemId = combo.source[1].id;
          combo.setValue(itemId)
          combo.setValue(itemId)
          return true

        [ns+combo_container]

        (result) -> @assert.ok(utils.checkResult(result), "status ok")
      )

      .pause(20)

      .execute(
        (ns) ->
          window.events[ns].filter(
            (event) -> event.name is "itemSelect").length

        [ns]

        (result) ->
          @assert.ok(utils.checkResult(result), "status ok")
          @assert.equal(result.value, 1, "selectItem was called #{result.value}")
      )

      .end()
