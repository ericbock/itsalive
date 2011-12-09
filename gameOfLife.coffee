root = exports ? this

class Game
	nextGen: (cells) ->
		next = new Cells
		positions = cells.cellPositions()
		for pos in positions
			if pos.cell.willLive(pos.liveNeighbors)
				next.addCell pos.x, pos.y
		next

class Cells
	constructor: ->
		@_cells = {}

	getLiveCount: -> 
		total = 0
		total++ for own key of @_cells when @_cells[key].isAlive
		total

	addCell: (x, y) ->
		cell = new Cell
		@_cells["#{x},#{y}"] = cell
		for pos in @neighborPositions x, y when not @_cells["#{pos.x},#{pos.y}"]?
			@_cells["#{pos.x},#{pos.y}"] = (new Cell).die()
		cell

	getCell: (x, y) ->
		@_cells["#{x},#{y}"] ? (new Cell).die()

	cellPositions: ->
		for own key, cell of @_cells
			[x, y] = key.split(',')
			{x: +x, y: +y, cell: cell, liveNeighbors: @liveNeighbors(+x, +y)}

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
		@

	live: () ->
		@isAlive = true
		@

	willLive: (neighbors) ->
		if @isAlive then neighbors in [2, 3] else neighbors is 3

root.Game = Game
root.Cells = Cells
root.Cell = Cell
