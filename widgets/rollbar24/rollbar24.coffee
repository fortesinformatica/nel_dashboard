class Dashing.Rollbar24 extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".rollbar").val(value).trigger('change')

  ready: ->
    rollbar = $(@node).find(".rollbar")
    rollbar.attr("data-bgcolor", rollbar.css("background-color"))
    rollbar.attr("data-fgcolor", rollbar.css("color"))
    rollbar.knob()
