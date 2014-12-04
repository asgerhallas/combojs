module.exports =
  "Combojs - structure - test 1" : (browser)->
    browser
      # .resizeWindow(0,0)
      .url("file:///C:/workspace/combojs/tests/index.html")
      .waitForElementVisible('body', 1000)
      # .globals.check_structure()
      .assert.elementPresent("#test-1 .empty-list")
      .assert.containsText("#test-1 .empty-list", "(ingen valgmuligheder)")
      .assert.hidden('#test-1 .combo-list-container')
      .click(".combo-button")
      # .pause(2000)
      .assert.containsText("#test-1 .empty-list", "(ingen valgmuligheder)")
      .end()
