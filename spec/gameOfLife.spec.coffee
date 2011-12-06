sinon = require 'sinon'
should = require 'should'
alive = require '../gameOfLife'

describe "Conway's Game of Life", ->
	game = {}

	beforeEach ->
		game = new alive.Game

	describe "when first created", ->
		it "should have no cells", ->
			game.getCells().should.have.length 0
	
	it "should add a cell to cells", ->
		spy = sinon.spy(game._cells, "addCell")
		game.addCell(0, 0)
		spy.called.should.be.true

describe "Cells", ->
	cells = {}

	beforeEach ->
		cells = new alive.Cells
	
	it "should start with no cells", ->
		cells.getCount().should.equal 0
	
	describe "adding a cell", ->
		it "should increase the count", ->
			count = cells.getCount()
			cells.addCell(0, 0)
			cells.getCount().should.equal count + 1

	describe "get cell", ->
		it "should return a dead cell if no cell exists at the coordinates", ->
			cells.getCell(100, 100).isAlive.should.be.false

		it "should return the actual cell at the coordinates if it exists", ->
			cells.addCell(100, 100)
			cells.getCell(100, 100).isAlive.should.be.true
	
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
