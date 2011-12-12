_ = require('underscore')._
should = require 'should'
alive = require '../gameOfLife'

describe "Conway's Game of Life", ->
	game = {}
	cells = {}

	beforeEach ->
		game = new alive.Game
		cells = new alive.Cells

	describe "next gen", ->
		it "should return a Cells collection", ->
			newCells = game.nextGen(cells)
			should.exist(newCells)
			newCells.should.be.instanceof alive.Cells

		describe "given no live cells", ->
			it "no live cells should get created", ->
				newCells = game.nextGen(cells)
				newCells.getLiveCount().should.equal 0

		describe "given one live cell", ->
			it "should return an empty collection", ->
				cells.addCell new alive.Point 0, 0
				newCells = game.nextGen(cells)
				newCells.getLiveCount().should.equal 0

		describe "given a 2x2 square", ->
			it "should return the same 2x2 square", ->
				cells.addCell new alive.Point 0, 0
				cells.addCell new alive.Point 0, 1
				cells.addCell new alive.Point 1, 0
				cells.addCell new alive.Point 1, 1
				newCells = game.nextGen(cells)
				newCells.getLiveCount().should.equal 4
				#ugh
				newCells.getCell(new alive.Point 0, 0).isAlive.should.be.true
				newCells.getCell(new alive.Point 0, 1).isAlive.should.be.true
				newCells.getCell(new alive.Point 1, 0).isAlive.should.be.true
				newCells.getCell(new alive.Point 1, 1).isAlive.should.be.true

		describe "given a 1x3 column", ->
			it "should return a 3x1 row with the same center", ->
				cells.addCell new alive.Point 1, 1
				cells.addCell new alive.Point 1, 2
				cells.addCell new alive.Point 1, 3
				newCells = game.nextGen(cells)
				newCells.getLiveCount().should.equal 3
				newCells.getCell(new alive.Point 0, 2).isAlive.should.be.true
				newCells.getCell(new alive.Point 1, 2).isAlive.should.be.true
				newCells.getCell(new alive.Point 2, 2).isAlive.should.be.true

describe "Cells", ->
	cells = {}

	beforeEach ->
		cells = new alive.Cells
	
	it "should start with no cells", ->
		cells.getLiveCount().should.equal 0
	
	describe "adding a cell", ->
		it "should increase the count", ->
			count = cells.getLiveCount()
			cells.addCell new alive.Point 0, 0
			cells.getLiveCount().should.be.greaterThan count

		it "should return the new cell", ->
			cell = cells.addCell new alive.Point 0, 0
			should.exist(cell)
			cell.should.be.an.instanceof alive.Cell

	describe "get cell", ->
		it "should return a dead cell if no cell exists at the coordinates", ->
			cells.getCell(new alive.Point 100, 100).isAlive.should.be.false

		it "should return the actual cell at the coordinates if it exists", ->
			cells.addCell new alive.Point 100, 100
			cells.getCell(new alive.Point 100, 100).isAlive.should.be.true
	
	describe "liveNeighbors", ->
		it "should return a count of the live neighbors", ->
			cells.addCell new alive.Point 0, 0 # live neighbor
			cells.addCell new alive.Point 2, 2 # live neighbor
			cells.addCell new alive.Point 10, 10 # not a neighbor
			cells.addCell(new alive.Point 0, 2).die() # dead neighbor
			cells.liveNeighbors(new alive.Point 1, 1).should.equal 2
	
describe "A Cell", ->
	cell = {}

	beforeEach ->
		cell = new alive.Cell

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

describe "A point", ->
	describe "neighbors", ->
		it "should return the positions of the neighbors surrounding a cell", ->
			x = y = 1
			positions = new alive.Point(x, y).neighbors()
			positions.should.have.length 8
			#ugh
			_.some(positions, (value) -> value.x is 0 and value.y is 0).should.be.true
			_.some(positions, (value) -> value.x is 1 and value.y is 0).should.be.true
			_.some(positions, (value) -> value.x is 2 and value.y is 0).should.be.true
			_.some(positions, (value) -> value.x is 0 and value.y is 1).should.be.true
			_.some(positions, (value) -> value.x is 2 and value.y is 1).should.be.true
			_.some(positions, (value) -> value.x is 0 and value.y is 2).should.be.true
			_.some(positions, (value) -> value.x is 1 and value.y is 2).should.be.true
			_.some(positions, (value) -> value.x is 2 and value.y is 2).should.be.true
