(($, window) ->
  class Combo
    # minium search term length to initate filtering
    # minLength: 1

    # max height in px on scrollbar window
    maxHeight: 300

    # number of list items in a page (PAGEUP / PAGEDOWN)
    pageSize: 10

    # whether the list should expand on input focus
    expandOnFocus: false

    # whether the active item should be selected on key TAB
    selectOnTab: true

    # sets the attribute tabindex
    tabIndex: null

    # selected item will default to first item in source instead of the empty string
    # on blur, if value is blank, selected item reverts to last selected item
    # throws if source is empty
    forceNonEmpty: false

    # onblur, when value does not match any item from list the
    # selected item reverts to last selected which may be null
    # the empty string is treated as a null value
    # throw if setValue is called with a non-matching value
    forceSelectionFromList: false

    # enable whether list can be closed
    keepListOpen: false

    # empty list text displayed as faux item
    emptyListText: '(ingen valgmuligheder)'

    # on list open by button click, does not reapply filters i.e. show entire list instead
    forceAllOnButtonClick: true

    # apply to filters, none, inText, firstInText, firstInWord, wholeWord
    matchBy: 'inText'

    # only shows enabled items in list
    onlyShowEnabled: false

    # enable spellcheck attribute
    spellcheck: false

    # value that - if set - will be used as submit value for the selected item
    valueField: 'id'

    # text that will be shown in textbox when item is selected
    titleField: null

    # text that will be shown in picker, and in textbox if not title is present
    displayField: 'text'

    # additional numerical searchable text, null means disabled
    litraField: null

    # value that decides if the item is enabled
    enabledField: () -> yes

    # e.g. given { modifier: '!', field: 'isReallySpecial' }, combo will only show records with the isReallySpecial field set to true when query is prefixed with !
    modifiers: []

    # e.g. given { alias: 'lag', field: 'layers' }, combo will be able to search the fields layers specifically using 'lag:' and a value
    specifications: []

    placeholder: ""

    # a new element will be shown in the top of the source list
    # the new element is a replica of the the element in the inputfield, unless it matches an allready existing element
    showUnmatchedRawValue: false

    # show classname if not false or null
    classNameOnEmpty: false
    
    # use to specify which items are rendered with which labels
    # ({ rawValue: string, item: T}) => { text: string, className: string} | null
    label: null

    # ---------
    source: []
    
    # secondary source to show in the bottom of the combo-list
    secondarySource: []

    disabled: true
    activeLi: null
    isExpanded: false
    inputLabel: null

    key:
      DOWN: 40
      END: 35
      ENTER: 13
      ESCAPE: 27
      HOME: 36
      INSERT: 45
      LEFT: 37
      PAGE_DOWN: 34
      PAGE_UP: 33
      RIGHT: 39
      SPACE: 32
      TAB: 9
      UP: 38
      BACKSPACE: 8
      DELETE: 46
      NUMPAD_ENTER: 108

    constructor: (wrapper, options = {}) ->
      @[key] = value for own key, value of options when value?

      if @forceSelectionFromList and @showUnmatchedRawValue
        throw new Error('invalid configuration, forceSelectionFromList and showUnmatchedRawValue cannot both be true')

      @el =
        $(wrapper)
          .addClass("combo-container")
          .on 'click', '.combo-list li', @onListClick

      @input = $(
        "<input type='text' class='combo-input' autocomplete='off' disabled='disabled'
          spellcheck='#{@spellcheck}' placeholder='#{@placeholder}'
          #{if @tabIndex? then "tabindex='#{@tabIndex}'" else ""}
          />")
        .bind
          keydown: @onKeyDown
          keyup: @onKeyUp
          mouseup: @onMouseUp
          # circumvent http://bugs.jquery.com/ticket/6705se
          focus: _.throttle @onFocus, 0
          blur: @onBlur
        .appendTo(@el)

      @button = $(
        '<button class="combo-button" tabindex="-1" disabled="disabled" />')
        .bind
          click: @onButtonClick
          mousedown: @suppressNextBlur
        .appendTo(@el)

      @list = $(
        '<ul class="combo-list"/>')
        .css(maxHeight: @maxHeight)
        .bind(mousedown: @onListMouseDown)
        .appendTo(@el)
        .hide()
        
      @link(@source, @secondarySource) if !_.isEmpty(@source) or !_.isEmpty(@secondarySource)
      @enable()
      @updateClassNames()
      @

    link: (source, secondarySource = []) ->
      @source = source
      @secondarySource = secondarySource
      @ensureSelection()
      @lastQuery = @input.val()

      @input.trigger 'linked'
      @

    itemValue: (item) => if item.__isRawValueItem then null else evaluate @valueField, item
    itemLitra: (item) => if item.__isRawValueItem then null else evaluate @litraField, item
    itemEnabled: (item) => if item.__isRawValueItem then true else evaluate @enabledField, item
    itemDisplay: (item) => if item.__isRawValueItem then item.__rawValue else evaluate @displayField, item
    itemTitle: (item) => if item.__isRawValueItem then item.__rawValue else @stripMarkup evaluate(@titleField, item) ? @itemDisplay(item)  
    itemModifier: (modifier) -> (item) => if item.__isRawValueItem then null else evaluate modifier.field, item
    itemSpecification: (specification) -> (item) => if item.__isRawValueItem then null else evaluate specification.field, item

    setValue: (value) => 
      @updateInputLabel()
      if @input.val() is value then return

      for item in @source when @itemValue(item) is value
        @selectItem item, forced: yes
        return
        
      for item in @secondarySource when @itemValue(item) is value
        @selectItem item, forced: yes
        return

      @input.val value
      @updateClassNames()

    selectItem: (item, options = {}) =>
      return if not @itemEnabled(item) and
                not options.forced

      if !item.__isRawValueItem and @input.val() is @itemTitle(item)
        # avoids circular updates in react
        # (model => setValue => trigger.itemSelect => model.change => setValue =>)
        @internalCollapse()
        return
      
      @input.val @itemTitle(item)
      @updateClassNames()
      @lastQuery = @input.val()
      @updateLastSelection()
      @internalCollapse()    
      _.delay (=> @input.trigger 'itemSelect', item), 10


    getSelectedValue: =>
      item = @getSelectedItemAndIndex()?.item
      if item? then @itemValue(item) else null

    getSelectedItem: =>
      @getSelectedItemAndIndex()?.item

    getSelectedIndex: =>
      @getSelectedItemAndIndex()?.index

    getSelectedItemAndIndex: => 
      for item, index in @source when @itemTitle(item) is @input.val()
        return {item, index}
        
      for item, index in @secondarySource when @itemTitle(item) is @input.val()
        return {item, index: index + @source.length}

    hasSelection: ->
      @getSelectedItemAndIndex()?

    getValue: =>
      @getSelectedValue() ? @getRawValue()

    getRawValue: =>
      @input.val()

    isEmpty: =>
      @input.val() is null or @input.val().trim() is ''

    selectLi: (li) =>
      comboId = $(li).data('combo-id')

      if comboId is 'emptylist-item'
        @internalCollapse()
        return

      if @source[comboId]
        @selectItem @source[comboId]
      else if @secondarySource[comboId - @source.length]
        @selectItem @secondarySource[comboId - @source.length]
      else if @showUnmatchedRawValue
        @selectItem  { __isRawValueItem: true, __rawValue: @stripMarkup @getRawValue() }
      else
        @selectItem null
      @refocus()

    onListClick: (event) =>
      @selectLi event.currentTarget

    onListMouseDown: (event) =>
      # if it's a list item (or subelement of list item), prevent the
      # close-on-blur in case of a "slow" click on the list (long mousedown)
      @suppressNextBlur()

      # if it's the scrollbar, send focus back to input after scrolling
      # this can't be done in mouseup as chrome won't send mouseup for
      # clicks on the scrollbar - only the list
      if not $(event.target).closest('ul.combo-list li').length
        @refocus()

    onButtonClick: (event) =>
      return if @disabled

      # if it's open and is not empty, close it
      if @isExpanded and $('li', @list).length
        @internalCollapse()
      else
        @searchAndExpand forceAll: @forceAllOnButtonClick

      @focus()

    onKeyDown: (event) =>
      return if @disabled

      if @isExpanded
        switch event.keyCode
          when @key.HOME
            @moveHome() and event.preventDefault()
          when @key.END
            @moveEnd() and event.preventDefault()
          when @key.PAGE_UP
            @movePreviousPage()
            event.preventDefault()
          when @key.PAGE_DOWN
            @moveNextPage()
            event.preventDefault()
          when @key.UP
            @movePrevious()
            event.preventDefault()
          when @key.DOWN
            @moveNext()
            event.preventDefault()
          when @key.ENTER, @key.NUMPAD_ENTER
            # Opera still allows the keypress to occur which causes forms to submit
            @input.one 'keypress', (keypress) => keypress.preventDefault()
            @selectLi @activeLi if @activeLi
            event.preventDefault()
            event.stopPropagation()
          when @key.TAB
            if @selectOnTab
              @selectLi @activeLi if @activeLi
              event.preventDefault()
              event.stopPropagation()
          when @key.ESCAPE
            @internalCollapse()
      else
        switch event.keyCode
          when @key.PAGE_UP, @key.PAGE_DOWN, @key.UP, @key.DOWN
            @searchAndExpand()
            event.preventDefault()
          when @key.ENTER
            @input.trigger 'enterpress'
            event.preventDefault();
          when @key.ESCAPE
            @input.select()

    onKeyUp: (event) =>
      return if @disabled

      @updateClassNames()
      @updateInputLabel()

      @updateLastSelection()

      return if @lastQuery is @input.val()

      switch event.keyCode
        when @key.BACKSPACE, @key.DELETE, @key.ENTER
          # do not open the list when deleting chars
          return unless @isExpanded

      @searchAndExpand()

    onMouseUp: =>
      return if @disabled
      @updateLastSelection()

    onFocus: (event, data) =>
      clearTimeout @closing
      return if @disabled

      if not data?.forcedFocus
        @input.trigger 'enter'
        @searchAndExpand() if @expandOnFocus
        _.defer => @input.select()

    onBlur: (event) =>
      if @disabled or @blurIsSuppressed
        @blurIsSuppressed = false
        return

      @ensureSelection()
      @internalCollapse()
      @input.trigger 'leave'

    ensureSelection: ->
      return if @disabled
      return if @hasSelection()

      if @isEmpty() and @forceNonEmpty
        if @lastSelection?
          return @selectItem @lastSelection.item
        if @source.length
          return @selectItem @source[0]
        if @secondarySource.length
          return @selectItem @secondarySource[0]
          
        throw new Error("consistency error: forceNonEmpty
                         require forced item selection but no items can be selected!
                         (either list is empty or all items are disabled)")

      if not @isEmpty() and @forceSelectionFromList
        if @lastSelection?
          return @selectItem @lastSelection.item
        @input.val ''
        @updateClassNames()
        @lastSelection = null

    updateLastSelection: =>
      return if not @forceSelectionFromList
      currentSelection = @getSelectedItemAndIndex()
      @lastSelection = currentSelection if currentSelection?

    suppressNextBlur: => @blurIsSuppressed = true if @input.is(':focus')

    refocus: ->
      # every time a focus is forced from within the combo effects that should
      # only follow a 'natural' focus must be suppressed
      # every focus is delayed a tiny bit to accomodate for timing issues where the current
      # focus might not yet have changed by last mouse/key event
      _.delay (=>
        if not @input.is(':focus')
          @input.trigger 'focus', { forcedFocus: true }),
      1

    focus: =>
      _.delay (=>
        if not @input.is(':focus')
          @input.trigger 'focus'),
      1

    activateSelectedItem: =>
      index = @getSelectedIndex()
      return if not index?
      for li in @list.children() when $(li).data('combo-id') == index
        @activate $(li)
        $(li).addClass('selected')

    stripMarkup: (text) ->
      text?.replace(/<br[^>]*>/g, " | ").replace(/<(?:.|\s)*?>/g, '').replace(/[\n\r]/g, '')

    searchAndExpand: (options = {}) =>
      @lastQuery = @input.val()

      if @hasSelection() or options.forceAll
        @renderFullList()
        @activateSelectedItem()
        @expand(options)
        return

      @renderFilteredList()
      @activate $('li:first', @list)
      @expand()

    buildFilters: (queryString) ->
      filters = []
      queryString = queryString.replace(/([.*+?^${}()|[\]\/\\])/g, "\\$1")
      queryString = queryString.replace(/([<>])/g, "")
      firstChar = queryString.substr(0, 1)

      for modifier in @modifiers
        if firstChar == modifier.modifier
          filters.push
            getter: @itemModifier(modifier)
            predicate: (value) -> value
          queryString = queryString.substr(1)

      for specification in @specifications
        specFinder = new RegExp(specification.alias + ":\\s*(\\w+)")
        specsInQuery = specFinder.exec(queryString)
        if specsInQuery
          filters.push
            getter: @itemSpecification(specification)
            predicate: (value) -> value is specsInQuery[1]
          queryString = queryString.replace(specFinder, "")

      queryStringSplit = queryString.split(" ")
      if @litraField?? and queryString.match(/^[#,]\w[\w\\\.,]*(\s|$)/)
        first = queryStringSplit.shift()
        filters.push
          getter: @itemLitra
          regex: new RegExp("^()(" + first.substr(1).replace(/,/g, "\\.") + ")", "i")
          predicate: (value) -> @regex.test value

      for currentWord in queryStringSplit when currentWord isnt ""
        currentWord = currentWord.replace(/\\\*/g, "[\\wæøåÆØÅ]*")
        currentWord = currentWord.replace(/\\\+/g, " ")
        dontSearchInsideTags = "(?![^><\\[\\]]*(>|\\]))"
        switch @matchBy
          when "none"
            break
          when "inText"
            filters.push
              getter: @itemDisplay
              regex: new RegExp("()(" + currentWord + ")()" + dontSearchInsideTags, "i")
              predicate: (value) -> @regex.test value
          when "firstInText"
            filters.push
              getter: @itemDisplay
              regex: new RegExp("^()(" + currentWord + ")()" + dontSearchInsideTags, "i")
              predicate: (value) -> @regex.test value
          when "firstInWord"
            filters.push
              getter: @itemDisplay
              regex: new RegExp("(^|[^\\wæøåÆØÅ\\[\\]])(" + currentWord + ")()" + dontSearchInsideTags, "i")
              predicate: (value) -> @regex.test value
          when "wholeWord"
            filters.push
              getter: @itemDisplay
              regex: new RegExp("(^|[^\\wæøåÆØÅ\\[\\]])(" + currentWord + ")($|[^\\wæøåÆØÅ\\[\\]])", "i")
              predicate: (value) -> @regex.test value
          else
            throw new Error "matchBy not set to a valid value"

      filters

    renderFilteredList: =>
      filters = if @input.val() is '' then [] else @buildFilters @input.val()
      @renderList @source, @secondarySource, filters

    renderFullList: =>
      @renderList @source, @secondarySource 

    renderList: (items, secondaryItems = [], filters = []) =>
      # for performance use native html manipulation
      # be aware never to attach events or data to list elements!

      htmls = [];

      if @showUnmatchedRawValue
        rawValue = @stripMarkup @getRawValue()
        if rawValue isnt  "" and !@hasSelection()
          if @label?(null,  @getRawValue())?
            htmls.push("<li class='unmatched-raw-value #{"has-label"}'>#{rawValue} #{@createLabel()}</li>")
          else 
            htmls.push("<li class='unmatched-raw-value'>#{rawValue}</li>")
   
      htmls.push(@renderItems(items, filters)...)
      htmls.push(@renderItems(secondaryItems, filters, 'secondary-source', items.length)...)   
      
      if htmls.length
        @list.html htmls.join('')
        # append classname "first" to the first secondary-source, it is style related
        @list.find('.secondary-source').first().addClass('first')
      else
        @list.html "<li class='disabled' data-combo-id='emptylist-item'>#{@emptyListText}</li>"
        
    renderItems: (items, filters, className = '', itemOffset = 0) =>
      for item, index in items
        continue if @onlyShowEnabled and not @itemEnabled(item)
        continue if not _.all filters, (filter) -> filter.predicate filter.getter(item)
        @renderItem item, index + itemOffset, filters, className

    renderItem: (item, index, filters, className) =>
      if @litraField? and (litra = @itemLitra(item))?
        text = "[#{litra}] #{@highlightValue(item, filters)}"
      else
        text = @highlightValue(item, filters)
      
      classes = [
        className,
        if @onlyShowEnabled or @itemEnabled(item) then 'enabled' else 'disabled',
        if @label?(item,  @getRawValue())? then "has-label" else ""
      ]

      if @createLabel(item) != ""
        "<li data-combo-id=\"#{index}\" class=\"#{classes.join(' ')}\">#{text} #{@createLabel(item)}</li>"
      else 
        "<li data-combo-id=\"#{index}\" class=\"#{classes.join(' ')}\">#{text}</li>"


    highlightValue: (item, filters) =>
      value = @itemDisplay(item)
      return null if not value?

      for filter in filters when filter.getter == @itemDisplay and filter.regex?
        value = value.replace(filter.regex, "<b>$2</b>")
      value

    moveNext: ->
      if @activeLi
        @activate @activeLi.next() unless @lastItemIsActive()
      else
        @moveHome()

    movePrevious: ->
      if @activeLi
        @activate @activeLi.prev() unless @firstItemIsActive()
      else
        @moveEnd()

    moveNextPage: ->
      @moveHome() unless @activeLi
      rest = @activeLi.nextAll()
      if rest.length >= @pageSize
        @activate rest.eq @pageSize-1
      else
        @moveEnd()

    movePreviousPage: ->
      @activate $('li:last', @list) unless @activeLi
      rest = @activeLi.prevAll()
      if rest.length >= @pageSize
        @activate rest.eq @pageSize-1
      else
        @moveHome()

    moveHome: ->
      @activate $('li:first', @list)

    moveEnd: ->
      @activate $('li:last', @list)

    activate: (item) ->
      @activeLi?.removeClass 'active'

      if item? and item.length
        item.addClass 'active'
        @activeLi = item
        @scrollIntoView()
      else
        @activeLi = null

      @activeLi

    firstItemIsActive: => @activeLi?[0] is $("li:first", @list)[0]
    lastItemIsActive: => @activeLi?[0] is $('li:last', @list)[0]

    scrollIntoView: =>
      return unless @isExpanded and @activeLi

      #for performance just reset scroll to top if the first item is active
      if @firstItemIsActive()
        @list.scrollTop 0 if @list[0].scrollTop > 0
        return

      # for performance only get list height once
      hasScroll = @list.prop('scrollHeight') > @maxHeight

      if hasScroll
        listTopBorder = parseFloat($.css(@list[0], 'borderTopWidth')) || 0
        listTopPadding = parseFloat($.css(@list[0], 'paddingTop')) || 0
        itemOffset = @activeLi.offset().top - @list.offset().top - listTopBorder - listTopPadding
        listHeight = @maxHeight
        currentScroll = @list.scrollTop()
        itemHeight = @activeLi.outerHeight()
        scroll =
          if itemOffset < 0
            currentScroll + itemOffset
          else if itemOffset + itemHeight > listHeight
            currentScroll + itemOffset - listHeight + itemHeight
        @list.scrollTop scroll

    expand: (options = {}) =>
      return if @disabled
      return if @isExpanded
      @el.addClass 'expanded'
      @isExpanded = true
      @list.show(options.callback)
      @scrollIntoView()
      @updateInputLabel()

    internalCollapse: =>
      if @keepListOpen
        @searchAndExpand()
      else
        @collapse()

    collapse: (options = {}) =>
      @el.removeClass 'expanded'
      @isExpanded = false
      @list.hide(options.callback)
      @updateInputLabel()

    disable: =>
      @disabled = true
      @input.attr disabled: true
      @button.attr disabled: true

    enable: =>
      @disabled = false
      @input.attr disabled: false
      @button.attr disabled: false

    evaluate = (fieldGetter, item) ->
      if not fieldGetter?
        null
      else if _.isFunction(fieldGetter)
        fieldGetter(item)
      else if _.isFunction(item[fieldGetter])
        item[fieldGetter]()
      else
        item[fieldGetter]

    updateClassNames: () ->
      if @classNameOnEmpty
        @input.toggleClass @classNameOnEmpty, not @getRawValue()
                
    createLabel: (item) ->
      label = @label?(item,  @getRawValue())
      if label? then "<span class='#{label.className}'>#{label.text}</span>" else ""
    
    updateInputLabel: () ->
      label = @createLabel(@getSelectedItem())
      if @inputLabel? and (@isExpanded or label == "")
          @inputLabel.remove() 
          @inputLabel = null
          @el.removeClass('has-label')
      else if @inputLabel == null and !@isExpanded and label != ""
        @inputLabel = $(label).insertAfter(@input) 
        @el.addClass('has-label')
          

#====================================================
# PLUGIN DEFINITION
#====================================================

  # Define the plugin
  # https://gist.github.com/rjz/3610858

  setters = ["link", "renderFullList"]
  $.fn.extend combo: (option, args...) ->

    value = @
    @each ->
      $this = $(@)
      plugin = $this.data('combo')

      if !plugin
        $this.data('combo', (data = new Combo(@, option)))

      else if typeof option == 'string'
        if not option of plugin then throw new Error("Unknown combo method #{option}")
        _value = plugin[option].apply(plugin, args)
        value = _value if !(option in setters)

    value
#====================================================
)(window.jQuery || require('jquery')(window), window)