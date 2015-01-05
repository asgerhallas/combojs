require('../../testutils.js').plug_macros()
data = ({ id: i, text: "#{i}", true: yes } for i in [1..100])

ns = "#temp_combo "
module.exports =

   "Option forceSelectionFromList: default=disabled": (browser) ->
      # whaaat!?
