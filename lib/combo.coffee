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

    # if input is nonempty and no exact matches exists,
    # the input will be replaced by either the empty string or
    # the currently selected item
    #
    # input must be empty or selected item
    forceSelectionFromList: false

    # input may never be empty
    # unless list is empty?
    allowEmpty: true

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
    enabledField: true

    # e.g. given { modifier: '!', field: 'isReallySpecial' }, combo will only show records with the isReallySpecial field set to true when query is prefixed with !
    modifiers: []

    # e.g. given { alias: 'lag', field: 'layers' }, combo will be able to search the fields layers specifically using 'lag:' and a value
    specifications: []

    # ---------
    source: []

    disabled: true
    activeLi: null
    isExpanded: false

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
      @[key] = value for own key, value of options

      @input = $(
        "<input type='text'
          class='combo-input'
          autocomplete='off'
          disabled='disabled'
          spellcheck='#{@spellcheck}'
          #{if @tabIndex? then 'tabindex=\'@tabIndex\''}/>")
        .bind
          keydown: @onKeyDown
          keyup: @onKeyUp
          mouseup: @onMouseUp
          # circumvent http://bugs.jquery.com/ticket/6705
          focus: _.throttle @onFocus, 0
          blur: @onBlur

      # @inputContainer = $(
      #   '<div class="combo-input-container" />')
      #   .append(@input)

      @el = $(wrapper)
            .addClass("combo-container")
            .append(@input)
            # must set actual html element as context for selector (see .live() reference)
            .on 'click', '.combo-list li', @onListClick

      @button = $(
        '<button class="combo-button"
          tabindex="-1"
          disabled="disabled" />')
        .insertAfter(@input)
        .bind
          click: @onButtonClick
          mousedown: @suppressNextBlur

      # @listContainer = $(
      #   '<div class="combo-list-container" />')
      #   .css(maxHeight: 0)
      #   .insertAfter(@button)

      @listContainer = @list = $('<ul class="combo-list"/>')
        .css(maxHeight: 0)
        .bind(mousedown: @onListMouseDown)
        .insertAfter(@button)

      @list.bgiframe() if $.fn.bgiframe
      @load(options.source) if options.source

      @

    load: (source) ->
      @source = for item in source
        fixedItem =
          litra: @evaluate @litraField, item
          value: @evaluate @valueField, item
          display: @evaluate @displayField, item
          title: @stripMarkup(
            if title = @evaluate @titleField, item then title
            else @evaluate @displayField, item
          )
          enabled: @evaluate @enabledField, item

        for modifier in @modifiers
          fixedItem[modifier.field] = @evaluate modifier.field, item

        for specification in @specifications
          fixedItem[specification.field] = @evaluate specification.field, item

        fixedItem

      @enable()
      @ensureSelection()
      @lastQuery = @input.val()

      @input.trigger 'loaded'

    setValue: (value) =>
      for item in @source when item.value is value
        @selectItem item, forced: yes
        return
      @input.val value

    getSelectedValue: =>
      item = @getSelectedItemAndIndex()?.item
      if item? then item.value else null

    getSelectedItem: =>
      @getSelectedItemAndIndex()?.item

    getSelectedIndex: =>
      @getSelectedItemAndIndex()?.index

    getSelectedItemAndIndex: =>
      return {item, index} for item, index in @source when item.title is @input.val()

    hasSelection: ->
      @getSelectedItemAndIndex()?

    getValue: =>
      @getSelectedValue() ? @getRawValue()

    getRawValue: =>
      @input.val()

    isEmpty: =>
      @input.val() is '' or @input.val() is null

    selectLi: (li) =>
      @selectItem @source[$(li).data('combo-id')]
      @refocus()

    selectItem: (item, options = {}) =>
      return if not item.enabled and not options.forced
      @input.val item.title
      @lastQuery = @input.val()
      @updateLastSelection()
      @internalCollapse()
      _.delay (=> @input.trigger 'itemSelect', title: item.title), 10

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
            @selectLi @activeLi if @activeLi and @selectOnTab
            if @source.length
              # allow tab on empty list
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
      return if @disabled or not @forceSelectionFromList or @hasSelection()

      if @lastSelection? and (not @isEmpty() or (@isEmpty() and not @allowEmpty))
        @selectItem @lastSelection.item
      else
        if not @allowEmpty
          @selectItem @source[0] if @source.length
        else
          @input.val ''
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
            property: modifier.field
            predicate: (value) -> value
          queryString = queryString.substr(1)

      for specification in @specifications
        specFinder = new RegExp(specification.alias + ":\\s*(\\w+)")
        specsInQuery = specFinder.exec(queryString)
        if specsInQuery
          filters.push
            property: specification.field
            predicate: (value) -> value is specsInQuery[1]
          queryString = queryString.replace(specFinder, "")

      queryStringSplit = queryString.split(" ")
      if @litraField?? and queryString.match(/^[#,]\w[\w\\\.,]*(\s|$)/)
        first = queryStringSplit.shift()
        filters.push
          property: 'litra'
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
              property: 'display'
              regex: new RegExp("()(" + currentWord + ")()" + dontSearchInsideTags, "i")
              predicate: (value) -> @regex.test value
          when "firstInText"
            filters.push
              property: 'display'
              regex: new RegExp("^()(" + currentWord + ")()" + dontSearchInsideTags, "i")
              predicate: (value) -> @regex.test value
          when "firstInWord"
            filters.push
              property: 'display'
              regex: new RegExp("(^|[^\\wæøåÆØÅ\\[\\]])(" + currentWord + ")()" + dontSearchInsideTags, "i")
              predicate: (value) -> @regex.test value
          when "wholeWord"
            filters.push
              property: 'display'
              regex: new RegExp("(^|[^\\wæøåÆØÅ\\[\\]])(" + currentWord + ")($|[^\\wæøåÆØÅ\\[\\]])", "i")
              predicate: (value) -> @regex.test value
          else
            throw new Error "matchBy not set to a valid value"

      filters

    positionList: ->
      @listContainer.css
        zIndex: @el.css('zIndex') + 1

    renderFilteredList: =>
      filters = if @input.val() is '' then [] else @buildFilters @input.val()
      @renderList @source, filters

    renderFullList: =>
      @renderList @source, []

    renderList: (items, filters) =>
      # for performance use native html manipulation
      # be aware never to attach events or data to list elements!

      htmls = for item, index in items when not @onlyShowEnabled or item.enabled
        @renderItem item, index, filters

      if htmls.length
        @list[0].innerHTML = htmls.join('')
      else
        @list[0].innerHTML = "<li class='disabled'>#{@emptyListText}</li>"

    renderItem: (item, index, filters) =>
      for filter in filters
        return unless filter.predicate item[filter.property]

      if @litraField? and (litra = item.litra)?
        text = "[#{litra}] #{@highlightValue(item, 'display', filters)}"
      else
        text = @highlightValue(item, 'display', filters)

      classes = [
        if @onlyShowEnabled or item.enabled then 'enabled' else 'disabled'
      ]

      "<li data-combo-id=\"#{index}\" class=\"#{classes.join(' ')}\">#{text}</li>"

    highlightValue: (item, property, filters) =>
      value = item[property]
      return null if not value?

      for filter in filters when filter.property == property and filter.regex?
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
      @listContainer.animate {maxHeight: @maxHeight}, duration: 60
      @list.animate {maxHeight: @maxHeight}, duration: 60, callback: options.callback
      @positionList()
      @scrollIntoView()

    internalCollapse: =>
      if @keepListOpen
        @searchAndExpand()
      else
        @collapse()

    collapse: (options = {}) =>
      @el.removeClass 'expanded'
      @isExpanded = false
      @listContainer.animate {maxHeight: 0}, duration: 60
      @list.animate {maxHeight: 0}, duration: 60, callback: options.callback

    disable: =>
      @disabled = true
      @input.attr disabled: true
      @button.attr disabled: true

    enable: =>
      @disabled = false
      @input.attr disabled: false
      @button.attr disabled: false

    # detach: ->
    #   @el.detach()

    # destroy: ->
    #   @el.remove()

    evaluate: (fieldGetter, item) ->
      if not fieldGetter?
        null
      else if _.isFunction(fieldGetter)
        fieldGetter(item)
      else if _.isFunction(item[fieldGetter])
        item[fieldGetter]()
      else
        item[fieldGetter]


#====================================================
# PLUGIN DEFINITION
#====================================================

  # Define the plugin
  # https://gist.github.com/rjz/3610858

  setters = ["load", "renderFullList"]
  $.fn.extend combo: (option, args...) ->

    values =  []
    @each ->
      $this = $(@)
      plugin = $this.data('combo')

      if !plugin
        $this.data('combo', (data = new Combo(@, option)))

      else if typeof option == 'string'
        if not option of plugin then throw new Error("Unknown combo method #{option}")
        _value = plugin[option].apply(plugin, args)
        if !(option in setters) then values.push(_value)

    switch values.length
      when 0 then return @
      when 1 then return values[0]
      else return values
#====================================================
)(window.jQuery, window)