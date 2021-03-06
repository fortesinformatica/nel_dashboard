class Dashing.Rollbar extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue
  @accessor 'arrowErrors', ->
    if @get('errors_last')
      if parseFloat(@get('errors_current')) > parseFloat(@get('errors_last')) then 'icon-arrow-up' else 'icon-arrow-down'

  @accessor 'arrowDistinct', ->
    if @get('errors_distinct_last')
      if parseFloat(@get('errors_distinct_current')) > parseFloat(@get('errors_distinct_last')) then 'icon-arrow-up' else 'icon-arrow-down'

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".rollbar").val(value).trigger('change')

  ready: ->
    rollbar = $(@node).find(".rollbar")
    rollbar.attr("data-bgcolor", rollbar.css("background-color"))
    rollbar.attr("data-fgcolor", rollbar.css("color"))
    rollbar.knob()
