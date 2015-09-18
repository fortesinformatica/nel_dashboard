class Dashing.Graph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    
    if points
      parseFloat(points[points.length - 1].y).toFixed(2)
    

  ready: ->
    container = $(@node).parent()
    
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'bar'
      stack: false,
      series: [
        {
                data: [ { x: 0, y: 40 }, { x: 1, y: 49 }, { x: 2, y: 10 }, { x: 3, y: 20 }, { x: 4, y: 30 }, { x: 5, y: 40 }, { x: 6, y: 50 } ]
                color: 'steelblue'
        }, 
        {
                data: [ { x: 0, y: 40 }, { x: 1, y: 30 }, { x: 2, y: 90 }, { x: 3, y: 18 }, { x: 4, y: 60 }, { x: 5, y: 85 }, { x: 6, y: 0 } ]
                color: 'lightblue'
        }
      ]
    )

    @graph.series[0].data = @get('points') if @get('points')
    @graph.series[1].data = @get('points2') if @get('points2')

    x_axis = new Rickshaw.Graph.Axis.X( {
      graph: @graph,
      orientation: 'bottom',
      pixelsPerTick: 60,
      tickFormat: (number) ->
        map = {
          0: 'Dom',
          1: 'Seg',
          2: 'Ter',
          3: 'Qua',
          4: 'Qui',
          5: 'Sex',
          6: 'Sab'
        }
        map[number]
    });
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, orientation: 'left', tickFormat: Rickshaw.Fixtures.Number.formatKMBT)

    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.points
      @graph.series[1].data = data.points2
      @graph.render()
