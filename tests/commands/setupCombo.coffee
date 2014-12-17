module.exports.command = () ->
  @
    .url("file:///C:/workspace/combojs/tests/index.html")
    .waitForElementVisible("body")