utils = require('../../testutils.js')
utils.plug_macros()


data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
module.exports =

  tags: ['valueField']

  "Option valueField: default=id": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data)
      .openComboList(ns)
      .click(ns+third_item)
      .execute(
        (ns) -> $(ns + ".combo_wrapper").combo('getSelectedValue'),
        [ns],
        (result) ->
          @assert.ok(utils.checkResult(result), "status ok")
          @assert.equal(result.value, 3, "value was ok")
      )
      .end()

  "Option valueField: altId": (browser) ->
    key = "altId"

    browser
      .setupCombo()
      .newComboElement(ns, data, {valueField: key})
      .openComboList(ns)
      .click(ns+third_item)
      .execute(
        (ns) -> $(ns + ".combo_wrapper").combo('getSelectedValue'),
        [ns],
        (result) ->
          @assert.ok(utils.checkResult(result), "status ok")
          @assert.equal(result.value, 33, "value was ok")
      )
      .end()
