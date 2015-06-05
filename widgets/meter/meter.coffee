class Dashing.Meter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue
  @accessor 'arrow', ->
    if @get('last')
      if parseFloat(@get('current')) > parseFloat(@get('last')) then 'icon-arrow-up' else 'icon-arrow-down'

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob()
