root = exports ? this

class Game
	cells: 
		length: 0
	addCell: (cell) ->
		@cells.length++

root.Game = Game
