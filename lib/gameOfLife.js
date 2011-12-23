(function() {
  var Cell, Cells, asPoint, gameStep, root,
    __slice = Array.prototype.slice,
    __hasProp = Object.prototype.hasOwnProperty;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  gameStep = function(cells) {
    var cell, next, willLive, _i, _len, _ref, _ref2;
    next = new Cells;
    _ref = cells.outlook();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref2 = _ref[_i], cell = _ref2.cell, willLive = _ref2.willLive;
      if (willLive) next.addCell.apply(next, cell.coords());
    }
    return next;
  };

  Cells = (function() {

    function Cells() {
      this._cells = {};
    }

    Cells.prototype.addCell = function() {
      var cell, coords, _ref;
      coords = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      cell = (_ref = new Cell()).at.apply(_ref, coords);
      this._initNeighbors(cell);
      return this._cells[coords] = cell;
    };

    Cells.prototype.getCell = function() {
      var coords;
      coords = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return this._cells[coords];
    };

    Cells.prototype.outlook = function() {
      var cell, key, _ref, _results;
      _ref = this._cells;
      _results = [];
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        cell = _ref[key];
        _results.push({
          cell: cell,
          willLive: cell.willLive(this.liveNeighbors(cell))
        });
      }
      return _results;
    };

    Cells.prototype.getLiveCount = function() {
      var cell, key;
      return ((function() {
        var _ref, _results;
        _ref = this._cells;
        _results = [];
        for (key in _ref) {
          if (!__hasProp.call(_ref, key)) continue;
          cell = _ref[key];
          if (cell.isAlive) _results.push(cell);
        }
        return _results;
      }).call(this)).length;
    };

    Cells.prototype.liveNeighbors = function(cell) {
      var coords;
      return ((function() {
        var _i, _len, _ref, _ref2, _results;
        _ref = cell.neighbors();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          coords = _ref[_i];
          if ((_ref2 = this.getCell(coords)) != null ? _ref2.isAlive : void 0) {
            _results.push(coords);
          }
        }
        return _results;
      }).call(this)).length;
    };

    Cells.prototype._initNeighbors = function(cell) {
      var coords, _i, _len, _ref, _ref2, _results;
      _ref = cell.neighbors();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        coords = _ref[_i];
        if (!(this._cells[coords] != null)) {
          _results.push(this._cells[coords] = (_ref2 = Cell.deadCell()).at.apply(_ref2, coords));
        }
      }
      return _results;
    };

    return Cells;

  })();

  Cell = (function() {

    Cell.deadCell = function() {
      return new Cell().die();
    };

    function Cell() {
      this.isAlive = true;
    }

    Cell.prototype.die = function() {
      this.isAlive = false;
      return this;
    };

    Cell.prototype.live = function() {
      this.isAlive = true;
      return this;
    };

    Cell.prototype.willLive = function(neighbors) {
      if (this.isAlive) {
        return neighbors === 2 || neighbors === 3;
      } else {
        return neighbors === 3;
      }
    };

    return Cell;

  })();

  asPoint = function() {
    this.at = function(x, y) {
      this.x = x;
      this.y = y;
      return this;
    };
    this.coords = function() {
      return [this.x, this.y];
    };
    this.neighbors = function() {
      return [[this.x - 1, this.y - 1], [this.x + 0, this.y - 1], [this.x + 1, this.y - 1], [this.x - 1, this.y + 0], [this.x + 1, this.y + 0], [this.x - 1, this.y + 1], [this.x + 0, this.y + 1], [this.x + 1, this.y + 1]];
    };
    return this;
  };

  asPoint.call(Cell.prototype);

  root.gameStep = gameStep;

  root.Cells = Cells;

  root.Cell = Cell;

}).call(this);
