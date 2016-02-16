# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  widget_columns = 8
  widget_margin_horizontal = 2
  widget_margin_vertical = 2
  widget_width = window.screen.width/widget_columns - 2 * widget_margin_horizontal
  widget_height = widget_width

  Dashing.widget_margins ||= [widget_margin_horizontal, widget_margin_vertical]
  Dashing.numColumns ||= widget_columns
  Dashing.widget_base_dimensions ||= [widget_width, widget_height]

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()
