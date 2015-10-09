require('../../testutils.js').plug_macros()

ns = ns_1275

module.exports =
  tags: ["InputCursorJumping"]
  
  "Cursor should not jump when writing og making white space in input value": (browser) ->   
    browser
      .setupCombo()
      .click(ns + combo_input)
      .click(ns + combo_input)
      .keys('FISK'.split(""))
      .keys([browser.Keys.LEFT_ARROW])
      .execute(
        (input, combo)->
          $(combo).data('combo').setValue("FISK")
          return $(input)[0].selectionStart
        [ns+combo_input, ns+combo_container]
        (result) ->
          @assert.equal(result.value, 3, "Cursor position #{result.value}")
     ) 
    .end()