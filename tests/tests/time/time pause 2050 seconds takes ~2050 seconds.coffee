require('../../testutils.js').plug_macros()

module.exports =

  "Time pause 2050 seconds takes ~2050 seconds": (browser) ->
    browser
      .assert.timer(
        (done) =>
          browser
            .pause(2050, done)
        ,
        (time) =>
          "> pausing 2050 seconds took #{time} ms"
      )
      .end()
