require('../../testutils.js').plug_macros()
data = ({
  id: i
  text: "#{i} a b",
  true: true
} for i in [1..1000])

ns = "#temp_combo "
comboId = "last"

module.exports =

  # TODO: refactor whitespace tests to separate test

  "Option matchBy: none": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'none' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "10 ")
      .assert.innerHTML(ns+combo_list + second_item, "2 a b")
      .assert.numberOfChildren(ns+combo_list+"li", 1000)

      .end()

  "Option matchBy: inText": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'inText' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "10 ")
      .verify.innerHTML(ns+combo_list + second_item, "<b>10</b>0 a b")
      .assert.numberOfChildren(ns+combo_list+"li", 21)

      .clearValue(ns+combo_input)
      .setValue(ns+combo_input, "00 ")
      .verify.innerHTML(ns+combo_list + first_item, "1<b>00</b> a b")
      .assert.numberOfChildren(ns+combo_list+"li", 10)

      .end()

  "Option matchBy: firstInText": (browser) ->
    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'firstInText' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "10 ")
      .assert.innerHTML(ns+combo_list + second_item, "<b>10</b>0 a b")
      .assert.numberOfChildren(ns+combo_list+"li", 12)

      .clearValue(ns+combo_input)
      .setValue(ns+combo_input, "00 ")
      .assert.numberOfChildren(ns+combo_list+"li", 0)

      .end()

  "Option matchBy: firstInWord": (browser) ->
    data = ({
      id: i
      text: "foo#{i} basbar",
      true: true
    } for i in [1..1000])

    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'firstInWord' })
      .click(ns+combo_input)

      .setValue(ns+combo_input, "foo")
      .assert.innerHTML(ns+combo_list + second_item, "<b>foo</b>2 basbar")
      .assert.numberOfChildren(ns+combo_list+"li", 1000)

      .clearValue(ns+combo_input)
      .setValue(ns+combo_input, "foo2")
      .assert.innerHTML(ns+combo_list + second_item, "<b>foo2</b>0 basbar")

      .clearValue(ns+combo_input)
      .setValue(ns+combo_input, "bar")
      .assert.numberOfChildren(ns+combo_list+"li", 0)

      .end()

  "Option matchBy: wholeWord": (browser) ->
    # ERROR, the devidor space disapears

    data = ({
      id: i
      text: "FooBasBazBar #{i} Foo#{ if (i%2) then 'Bas' else 'Baz' }Bar",
      true: true
    } for i in [1..1000])

    browser
      .setupCombo()

      .newComboElement(ns, data, { matchBy: 'wholeWord' })
      .click(ns+combo_input)
      .setValue(ns+combo_input, "Foo")
      .assert.numberOfChildren(ns+combo_list+"li", 0)

      .clearValue(ns+combo_input)
      .setValue(ns+combo_input, "FooBasBar ")
      .verify.innerHTML(ns+combo_list + first_item, "FooBasBazBar 1 <b>FooBasBar</b>")
      .verify.innerHTML(ns+combo_list + second_item, "FooBasBazBar 3 <b>FooBasBar</b>")
      .assert.numberOfChildren(ns+combo_list+"li", 500)

      .clearValue(ns+combo_input)
      .setValue(ns+combo_input, browser.Keys.BACK_SPACE)
      .setValue(ns+combo_input, "FooBasBazBar FooBasBar ")
      .verify.innerHTML(ns+combo_list + first_item, "<b>FooBasBazBar</b> 1 <b>FooBasBar</b>")
      .verify.innerHTML(ns+combo_list + second_item, "<b>FooBasBazBar</b> 3 <b>FooBasBar</b>")
      .assert.numberOfChildren(ns+combo_list+"li", 500)

      .end()