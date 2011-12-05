root = exports ? this

class Game
	cells: 
		length: 0
	addCell: (cell) ->
		@cells.length++

class Cell
	constructor: (@X, @Y) ->
	isAlive: true

	die: () ->
		@isAlive = false

	live: () ->
		@isAlive = true

	willLive: (neighbors) ->
		neighbors in [2, 3]

root.Game = Game
root.Cell = Cell
