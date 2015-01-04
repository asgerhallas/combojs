module.exports.command = () ->
  @
    .url(@globals.url)
    .waitForElementVisible("body")