root = exports ? this

class Game
	nextGen: (cells) ->
		next = new Cells
		for {x, y, cell, liveNeighbors} in cells.cellPositions()
			next.addCell x, y if cell.willLive(liveNeighbors)
		next

class Cells
	constructor: ->
		@_cells = {}

	getLiveCount: -> 
		total = 0
		total++ for own key of @_cells when @_cells[key].isAlive
		total

	addCell: (x, y) ->
		for point in @neighborPositions x, y when not @_cells[point]?
			@_cells[point] = Cell.deadCell()

		@_cells[new Point x, y] = new Cell

	getCell: (x, y) ->
		@_cells[new Point x, y] ? Cell.deadCell()

	cellPositions: ->
		for own key, cell of @_cells
			[x, y] = key.split(',')
			{x: +x, y: +y, cell: cell, liveNeighbors: @liveNeighbors(+x, +y)}

	neighborPositions: (x, y) ->
		[
			new Point x - 1, y - 1
			new Point x + 0, y - 1
			new Point x + 1, y - 1
			new Point x - 1, y + 0
			new Point x + 1, y + 0
			new Point x - 1, y + 1
			new Point x + 0, y + 1
			new Point x + 1, y + 1
		]

	liveNeighbors: (x, y) ->
		total = 0
		total++ for pos in @neighborPositions x, y when @getCell(pos.x, pos.y).isAlive
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

root.Game = Game
root.Cells = Cells
root.Cell = Cell
