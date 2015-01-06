require('../../testutils.js').plug_macros()
data = ({
  id: i
  text: "#{i}",
  a: if (i%2!=0) then "foo#{i}" else "bar#{i}",
  b: if (i%2!=0) then "bas#{i}" else "baz#{i}",
  true: true
} for i in [1..100])

specifications = [{alias: 'foobar', field: 'a'}] # why not a list? oo

ns = "#temp_combo "
comboId = "last"

module.exports =

  tags: ['bar'],

  # "Option specifications: default:=disabled": (browser) ->
  #   browser
  #     .setupCombo()
  #     .newComboElement(ns, data)
  #     .click(ns+combo_input)

  #     .setValue(ns+combo_input, "!")
  #     .assert.numberOfChildren(ns+combo_list+"li", 0)

  #     .setValue(ns+combo_input, browser.Keys.BACK_SPACE)
  #     .setValue(ns+combo_input, "%")
  #     .assert.numberOfChildren(ns+combo_list+"li", 0)

  #     .end()

  "Option specifications: given list of two specifications": (browser) ->
    browser.assert.equal(true, false, "NOT IMPLEMENTED")

    # browser
      # .setupCombo()
      # .newComboElement(ns, data, { specifications: specifications })
      # .click(ns+combo_input)

      # .setValue(ns+combo_input, "foobar:")
      # .pause(4000000)
      # .assert.innerHTML(ns+first_item, "[1] 1")
      # .assert.innerHTML(ns+second_item, "[3] 3")
      # .assert.innerHTML(ns+third_item, "[5] 5")
      # .assert.numberOfChildren(ns+combo_list+"li", 50)

      # .setValue(ns+combo_input, "5")
      # .assert.innerHTML(ns+first_item, "[5] <b>5</b>")
      # # (5,15,25..95) + (51,53,57,59) = 10+4
      # .assert.numberOfChildren(ns+combo_list+"li", 14)

      # .setValue(ns+combo_input, browser.Keys.BACK_SPACE)
      # .setValue(ns+combo_input, browser.Keys.BACK_SPACE)

      # .setValue(ns+combo_input, "%")
      # .assert.innerHTML(ns+first_item, "[1] 1")
      # .assert.innerHTML(ns+second_item, "[2] 2")
      # .assert.innerHTML(ns+third_item, "[4] 4")
      # .assert.numberOfChildren(ns+combo_list+"li", 67)

      # .setValue(ns+combo_input, "4")
      # .assert.innerHTML(ns+first_item, "[4] <b>4</b>")
      # .assert.numberOfChildren(ns+combo_list+"li", 13)

      # .end()
