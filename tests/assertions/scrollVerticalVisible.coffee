isScrolledVerticalIntoView = (containerSel, elmSel) ->
  container = $(containerSel)
  throw Error("ambigous use of selector: " + containerSel)  if container.length isnt 1
  docViewTop = container.scrollTop()
  docViewBottom = docViewTop + container.innerHeight()
  containerHeight = container.innerHeight()
  elm = container.find(elmSel)
  throw Error("ambigous use of selector: " + containerSel + " " + elmSel)  if elm.length isnt 1
  elmOffsetUpperBound = elm.position().top
  elmOffsetLowerBound = elmOffsetUpperBound + elm.outerHeight()

  elmOffsetLowerBound >= 0 and elmOffsetUpperBound <= containerHeight

  # manual test
  # [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18].forEach(function(i) {
  #   console.log("item index:",i,isScrolledVerticalIntoView('#medium-list ul', 'li:nth-child('+i+')'));
  # });

exports.assertion = (containerSel, elmSel, msg) ->
  ###
  The message which will be used in the test output and
  inside the XML reports
  @type {string}
  ###

  @message = msg or
            "element #{containerSel + elmSel} should have been scroll visible"

  ###
  A value to perform the assertion on. If a function is
  defined, its result will be used.
  @type {function|*}
  ###
  @expected = true

  ###
  The method which performs the actual assertion. It is
  called with the result of the value method as the argument.
  @type {function}
  ###
  @pass = (value) ->
    value is @expected


  ###
  The method which returns the value to be used on the
  assertion. It is called with the result of the command's
  callback as argument.
  @type {function}
  ###
  @value = (result) ->
    result.value



  ###
  Performs a protocol command/action and its result is
  passed to the value method via the callback argument.
  @type {function}
  ###
  @command = (callback) ->
    @client.api.execute(
      isScrolledVerticalIntoView
      [containerSel, elmSel],
      callback
    )

  @