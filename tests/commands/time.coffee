require('../testutils.js').plug_macros()

module.exports.command = (f, reporter) ->
  # consider getting this out in xml file?
  start = new Date().getTime()
  f(() =>
    end = new Date().getTime()
    reporter(end - start)
  )

  @