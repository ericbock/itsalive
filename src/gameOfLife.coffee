root = exports ? this

gameStep = (cells) ->
	next = new Cells
	next.addCell cell.coords()... for {cell, willLive} in cells.outlook() when willLive
	next

class Cells
	constructor: -> @_cells = {}

	addCell: (coords...) ->
		cell = new Cell().at coords...
		@_initNeighbors cell
		@_cells[coords] = cell

	getCell: (coords...) -> @_cells[coords]

	outlook: ->
		for own key, cell of @_cells
			{
				cell: cell
				willLive: cell.willLive(@liveNeighbors cell)
			}

	getLiveCount: -> 
		(cell for own key, cell of @_cells when cell.isAlive).length

	liveNeighbors: (cell) ->
		(coords for coords in cell.neighbors() when @getCell(coords)?.isAlive).length

	_initNeighbors: (cell) ->
		for coords in cell.neighbors() when not @_cells[coords]?
			@_cells[coords] = Cell.deadCell().at coords...

class Cell
	@deadCell: -> new Cell().die()

	constructor: -> @isAlive = true

	die: () ->
		@isAlive = false
		@

	live: () ->
		@isAlive = true
		@

	willLive: (neighbors) ->
		if @isAlive then neighbors in [2, 3] else neighbors is 3

# point logic as mixin
asPoint = () ->
	@at = (@x, @y) -> @
	
	@coords = () -> [@x, @y]

	@neighbors = () ->
		[
			[@x - 1, @y - 1], [@x + 0, @y - 1], [@x + 1, @y - 1]
			[@x - 1, @y + 0],                   [@x + 1, @y + 0]
			[@x - 1, @y + 1], [@x + 0, @y + 1], [@x + 1, @y + 1]
		]

	return @

asPoint.call Cell::

root.gameStep = gameStep
root.Cells = Cells
root.Cell = Cell
