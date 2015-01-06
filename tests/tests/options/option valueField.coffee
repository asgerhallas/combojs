require('../../testutils.js').plug_macros()
data = ({ id: i, altId: i*11, text: "#{i}", true: i%3==0 } for i in [1..100])

ns = "#temp_combo "
comboId = "last"
module.exports =

  "Option valueField: default=id": (browser) ->
    browser
      .setupCombo()
      .newComboElement(ns, data, null, comboId)
      .openComboList(ns)
      .click(ns+third_item)
      .execute(
        (comboId) -> window.temp[comboId].getSelectedValue(),
        [comboId],
        (result) ->
          @assert.equal(result.status, 0, "status ok")
          @assert.equal(result.value, 3, "value was ok")
      )
      .end()

  "Option valueField: altId": (browser) ->
    key = "altId"

    browser
      .setupCombo()
      .newComboElement(ns, data, {valueField: key}, comboId)
      .openComboList(ns)
      .click(ns+third_item)
      .execute(
        (comboId) -> window.temp[comboId].getSelectedValue(),
        [comboId],
        (result) ->
          @assert.equal(result.status, 0, "status ok")
          @assert.equal(result.value, 33, "value was ok")
      )
      .end()
