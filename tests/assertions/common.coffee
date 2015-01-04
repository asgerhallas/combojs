#====================================================
  # SUBROUTINES
  #====================================================
  module.exports.isScrollVerticalVisible = (containerSel, elmSel) ->
    container = $(containerSel)
    if container.length isnt 1 
      throw Error("Ambigous use of selector: " + containerSel)  

    docViewTop = container.scrollTop()
    docViewBottom = docViewTop + container.innerHeight()

    containerHeight = container.innerHeight()
    elm = container.find(elmSel)
    if elm.length isnt 1
      throw Error("Ambigous use of selector: " + containerSel + " " + elmSel)

    elmOffsetUpperBound = elm.position().top
    elmOffsetLowerBound = elmOffsetUpperBound + elm.outerHeight()

    return elmOffsetLowerBound >= 0 and 
           elmOffsetUpperBound <= containerHeight
  #====================================================