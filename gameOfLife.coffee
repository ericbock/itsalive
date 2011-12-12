root = exports ? this

class Game
	nextGen: (cells) ->
		next = new Cells
		next.addCell point for {point, willLive} in cells.outlook() when willLive
		next

class Cells
	constructor: ->
		@_cells = {}

	getLiveCount: -> 
		total = 0
		total++ for own key of @_cells when @_cells[key].isAlive
		total

	addCell: (point) ->
		@_initNeighbors point
		@_cells[point] = new Cell

	getCell: (point) ->
		@_cells[point] ? Cell.deadCell()

	outlook: ->
		for own key, cell of @_cells
			coords = (+coord for coord in key.split ',')
			point = new Point coords...
			willLive = cell.willLive @liveNeighbors(point)
			{point: point, willLive: willLive}

	liveNeighbors: (point) ->
		total = 0
		total++ for neighbor in point.neighbors() when @getCell(neighbor).isAlive
		total

	_initNeighbors: (point) ->
		for neighbor in point.neighbors() when not @_cells[neighbor]?
			@_cells[neighbor] = Cell.deadCell()

class Cell
	@deadCell: ->
		new Cell().die()

	constructor: ->
		@isAlive = true

	die: () ->
		@isAlive = false
		@

	live: () ->
		@isAlive = true
		@

	willLive: (neighbors) ->
		if @isAlive then neighbors in [2, 3] else neighbors is 3

class Point
	constructor: (@x, @y) ->
	toString: () -> "#{@x},#{@y}"

	neighbors: () ->
		[
			new Point @x - 1, @y - 1
			new Point @x + 0, @y - 1
			new Point @x + 1, @y - 1
			new Point @x - 1, @y + 0
			new Point @x + 1, @y + 0
			new Point @x - 1, @y + 1
			new Point @x + 0, @y + 1
			new Point @x + 1, @y + 1
		]


root.Game = Game
root.Cells = Cells
root.Cell = Cell
root.Point = Point
