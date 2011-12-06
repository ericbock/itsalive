root = exports ? this

class Game
	_cells: {}

	constructor: ->
		@_cells = new Cells()

	getCells: -> []

	addCell: (x, y) ->
		@_cells.addCell(x, y)

class Cells
	length: 0
	addCell: (x, y) ->

class Cell
	isAlive: true

	die: () ->
		@isAlive = false

	live: () ->
		@isAlive = true

	willLive: (neighbors) ->
		if @isAlive then neighbors in [2, 3] else neighbors is 3

root.Game = Game
root.Cell = Cell
