root = exports ? this

class Game
	nextGen: (cells) ->
		next = new Cells
		for {point, cell, liveNeighbors} in cells.cellPositions()
			next.addCell point if cell.willLive(liveNeighbors)
		next

class Cells
	constructor: ->
		@_cells = {}

	getLiveCount: -> 
		total = 0
		total++ for own key of @_cells when @_cells[key].isAlive
		total

	addCell: (point) ->
		for neighbor in point.neighborPositions() when not @_cells[neighbor]?
			@_cells[neighbor] = Cell.deadCell()

		@_cells[point] = new Cell

	getCell: (point) ->
		@_cells[point] ? Cell.deadCell()

	cellPositions: ->
		for own key, cell of @_cells
			[x, y] = key.split(',')
			point = new Point +x, +y
			{point: point, cell: cell, liveNeighbors: @liveNeighbors(point)}

	liveNeighbors: (point) ->
		total = 0
		total++ for neighbor in point.neighborPositions() when @getCell(neighbor).isAlive
		total

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

	neighborPositions: () ->
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
