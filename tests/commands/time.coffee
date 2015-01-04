require('../testutils.js').plug_macros()

module.exports.command = (f, reporter) ->

  start = new Date().getTime()
  f(() =>
    end = new Date().getTime()
    reporter(end - start)
  )

  @