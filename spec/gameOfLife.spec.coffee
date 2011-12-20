{ _ } = require('underscore')
should = require 'should'
{ gameStep, Cells, Cell } = require '../gameOfLife'

describe "Conway's Game of Life", ->
	cells = {}

	beforeEach ->
		cells = new Cells

	describe "gameStep", ->
		it "should return a Cells collection", ->
			newCells = gameStep(cells)
			should.exist(newCells)
			newCells.should.be.instanceof Cells

		describe "given no live cells", ->
			it "no live cells should get created", ->
				cells.followSequence(
					[
						[ 0 ]
					]
					[
						[ 0 ]
					]
				)

		describe "given one live cell", ->
			it "should return an empty collection", ->
				cells.followSequence(
					[
						[ 1 ]
					]
					[
						[ 0 ]
					]
				)

		describe "block", ->

			it "should return the same block", ->
				cells.followSequence( 
					[
						[1, 1]
						[1, 1]
					]
					[
						[1, 1]
						[1, 1]
					]
				)

		describe "blinker", ->

			it "rotates", ->
				cells.followSequence( 
					[
						[0, 1, 0]
						[0, 1, 0]
						[0, 1, 0]
					]
					[
						[0, 0, 0]
						[1, 1, 1]
						[0, 0, 0]
					]
					[
						[0, 1, 0]
						[0, 1, 0]
						[0, 1, 0]
					]
				)

		describe "glider", ->
			it "moves", ->
				cells.followSequence(
					[
						[0, 1, 0]
						[0, 0, 1]
						[1, 1, 1]
					]
					[
						[0, 0, 0]
						[1, 0, 1]
						[0, 1, 1]
						[0, 1, 0]
					]
					[
						[0, 0, 0]
						[0, 0, 1]
						[1, 0, 1]
						[0, 1, 1]
					]
					[
						[0, 0, 0, 0]
						[0, 1, 0, 0]
						[0, 0, 1, 1]
						[0, 1, 1, 0]
					]
					[
						[0, 0, 0, 0]
						[0, 0, 1, 0]
						[0, 0, 0, 1]
						[0, 1, 1, 1]
					]
				)

	given = (locations) ->
		for row, y in locations
			for col, x in row when col is 1
				@addCell x, y
		return @

	shouldBecome = (locations) ->
		newCells = gameStep @
		for row, y in locations
			for col, x in row when col is 1
				newCells.getCell(x, y).isAlive.should.be.true
			for col, x in row when col isnt 1
				newCells.getCell(x, y)?.isAlive.should.be.false
		newCells

	followSequence = (initial, states...) ->
		current = @.given initial
		for state in states
			current = current.shouldBecome state
		current

	Cells::given = given
	Cells::shouldBecome = shouldBecome
	Cells::followSequence = followSequence

describe "Cells", ->
	cells = {}

	beforeEach ->
		cells = new Cells
	
	it "should start with no cells", ->
		cells.getLiveCount().should.equal 0
	
	describe "adding a cell", ->
		it "should increase the count", ->
			count = cells.getLiveCount()
			cells.addCell 0, 0
			cells.getLiveCount().should.be.greaterThan count

		it "should return the new cell", ->
			cell = cells.addCell 0, 0
			should.exist(cell)
			cell.should.be.an.instanceof Cell

	describe "get cell", ->
		it "should return undefined if no cell exists at the coordinates", ->
			should.not.exist cells.getCell(100, 100)

		it "should return the actual cell at the coordinates if it exists", ->
			cells.addCell 100, 100
			cells.getCell(100, 100).isAlive.should.be.true
	
	describe "liveNeighbors", ->
		it "should return a count of the live neighbors", ->
			cell = cells.addCell 1, 1

			cells.addCell 0, 0 # live neighbor
			cells.addCell 2, 2 # live neighbor
			cells.addCell 10, 10 # not a neighbor
			cells.addCell(0, 2).die() # dead neighbor
			cells.liveNeighbors(cell).should.equal 2
	
describe "A Cell", ->
	cell = {}

	beforeEach ->
		cell = new Cell

	it "should start out alive", ->
		cell.isAlive.should.be.true
	
	it "should die on die", ->
		cell.die()
		cell.isAlive.should.be.false

	it "should live on live", ->
		cell.die()
		cell.live()
		cell.isAlive.should.be.true
	
	describe "when alive", ->

		beforeEach ->
			cell.live()

		describe "with fewer than two neighbors", ->
			it "is doomed to die from under-population", ->
				cell.willLive(i).should.be.false for i in [0...2]

		describe "with two or three neighbors", ->
			it "will survive", ->
				cell.willLive(i).should.be.true for i in [2..3]

		describe "with more than three neighbors", ->
			it "is doomed to die from over-population", ->
				cell.willLive(i).should.be.false for i in [4..8]

	describe "when dead", ->

		beforeEach ->
			cell.die()

		describe "with exactly three neighbors", ->
			it "will come to life", ->
				cell.willLive(3).should.be.true

		describe "with some number of neighbors other than three", ->
			it "will stay dead", ->
				cell.willLive(i).should.be.false for i in [0..2].concat([4..8])

	describe "neighbors", ->
		it "should return the positions of the neighbors surrounding the cell", ->
			x = y = 1
			positions = new Cell().at(x, y).neighbors()
			positions.should.have.length 8
			#ugh
			_.some(positions, (value) -> value[0] is 0 and value[1] is 0).should.be.true
			_.some(positions, (value) -> value[0] is 1 and value[1] is 0).should.be.true
			_.some(positions, (value) -> value[0] is 2 and value[1] is 0).should.be.true
			_.some(positions, (value) -> value[0] is 0 and value[1] is 1).should.be.true
			_.some(positions, (value) -> value[0] is 2 and value[1] is 1).should.be.true
			_.some(positions, (value) -> value[0] is 0 and value[1] is 2).should.be.true
			_.some(positions, (value) -> value[0] is 1 and value[1] is 2).should.be.true
			_.some(positions, (value) -> value[0] is 2 and value[1] is 2).should.be.true
