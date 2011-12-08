root = exports ? this

class Game
	nextGen: (cells) ->
		new Cells

class Cells
	constructor: ->
		@_cells = {}

	getCount: -> 
		total = 0
		for own key of @_cells then total++
		total

	addCell: (x, y) ->
		@_cells["#{x},#{y}"] = new Cell

	getCell: (x, y) ->
		cell = @_cells["#{x},#{y}"]
		if not cell
			cell = new Cell
			cell.die()
		cell

	neighborPositions: (x, y) ->
		[
			{ x: x - 1, y: y - 1 }
			{ x: x + 0, y: y - 1 }
			{ x: x + 1, y: y - 1 }
			{ x: x - 1, y: y + 0 }
			{ x: x + 1, y: y + 0 }
			{ x: x - 1, y: y + 1 }
			{ x: x + 0, y: y + 1 }
			{ x: x + 1, y: y + 1 }
		]

	liveNeighbors: (x, y) ->
		total = 0
		total++ for pos in @neighborPositions x, y when @getCell(pos.x, pos.y).isAlive
		total

class Cell
	constructor: ->
		@isAlive = true

	die: () ->
		@isAlive = false

	live: () ->
		@isAlive = true

	willLive: (neighbors) ->
		if @isAlive then neighbors in [2, 3] else neighbors is 3

root.Game = Game
root.Cells = Cells
root.Cell = Cell
