exports.command = exports.command or {}

exports.command = () ->
  this
    .assert.elementPresent("#test-1 .combo-button")
    .assert.elementPresent("#test-1 .combo-container")
    .assert.elementPresent("#test-1 .combo-input-container")
    .assert.elementPresent("#test-1 .combo-input")
    .assert.elementPresent("#test-1 .combo-button")
    .assert.elementPresent("#test-1 .combo-list-container")
    .assert.elementPresent("#test-1 .combo-list")
  this