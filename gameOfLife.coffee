root = exports ? this

class Game
	constructor: ->
		@_cells = new Cells()

	getCells: -> []

	addCell: (x, y) ->
		@_cells.addCell(x, y)

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
