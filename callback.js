// Generated by CoffeeScript 1.7.1
(function() {
  var Callback, custom,
    __slice = [].slice;

  custom = {};

  Callback = (function() {
    function Callback(callback) {
      if (callback == null) {
        callback = null;
      }
      if (callback === null) {
        callback = function() {};
      }
      if (callback.constructor !== Function) {
        throw new Error("That ain't no function, missy");
      }
      this.callback = callback;
      this.fired = [];
      this.cancelled = false;
      this["this"] = null;
      this.pass = null;
      this.conditional = null;
      this.error = null;
    }

    Callback.prototype.config = function(vars) {
      var property;
      if (typeof vars !== 'object') {
        return false;
      }
      for (property in vars) {
        if (this.hasOwnProperty(property)) {
          this[property] = vars[property];
        }
      }
      return this;
    };

    Callback.prototype.cancel = function(target, event) {
      if (target == null) {
        target = null;
      }
      if (event == null) {
        event = null;
      }
      if (target === null) {
        this.cancelled = true;
      } else {
        new Callback((function(_this) {
          return function() {
            return _this.cancelled = true;
          };
        })(this)).when(target, event);
      }
      return this;
    };

    Callback.prototype.renew = function(target, event) {
      if (target == null) {
        target = null;
      }
      if (event == null) {
        event = null;
      }
      if (target === null) {
        this.cancelled = false;
      } else {
        new Callback((function(_this) {
          return function() {
            return _this.cancelled = false;
          };
        })(this)).when(target, event);
      }
      return this;
    };

    Callback.prototype["catch"] = function(callback) {
      if (!callback) {
        return;
      }
      this.error = callback;
      return this;
    };

    Callback.prototype.when = function(target, event) {
      var repeat, time;
      if (!target) {
        return;
      }
      switch (target.constructor) {
        case String:
          if (!custom[target]) {
            custom[target] = new Array();
          }
          custom[target].push(this);
          break;
        case Number:
          time = target;
          repeat = event;
          if (repeat) {
            setInterval(((function(_this) {
              return function() {
                return _this.invoke();
              };
            })(this)), time);
          } else {
            setTimeout(((function(_this) {
              return function() {
                return _this.invoke();
              };
            })(this)), time);
          }
          break;
        default:
          try {
            event = event.toLowerCase();
          } catch (_error) {}
          if (event === 'load') {
            switch (target.readyState) {
              case 'complete':
              case 4:
                this.invoke(target);
            }
          }
          if (typeof target.addEventListener === "function") {
            target.addEventListener(event, (function(_this) {
              return function(event) {
                return _this.invoke(event);
              };
            })(this));
          }
      }
      return this;
    };

    Callback.prototype["if"] = function(conditional) {
      if (typeof conditional !== 'function') {
        return false;
      }
      this.conditional = conditional;
      return this;
    };

    Callback.prototype.invoke = function() {
      var arg, condition, error;
      arg = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (this.cancelled) {
        return false;
      }
      if (this.conditional) {
        condition = this.conditional();
        if (!condition) {
          return condition;
        }
      }
      try {
        if ((this['this'] != null) && (this.pass != null)) {
          this.callback.call(this['this'], this.pass);
        } else if ((this['this'] != null) && (arg != null)) {
          this.callback.apply(this['this'], arg);
        } else if ((this['this'] != null) && !arg) {
          this.callback.call(this['this']);
        } else if (this.pass != null) {
          this.callback.call(this, this.pass);
        } else if (arg != null) {
          this.callback.apply(this, arg);
        } else {
          this.callback();
        }
        this.fired.push(new Date());
      } catch (_error) {
        error = _error;
        if (this.error) {
          this.error(error);
        } else {
          throw error;
        }
      }
      return this;
    };

    return Callback;

  })();

  Callback.fire = function() {
    var args, callback, event, _i, _len, _ref;
    event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (typeof event !== 'string') {
      return;
    }
    if (!custom[event]) {
      return;
    }
    _ref = custom[event];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      try {
        if (args.length) {
          callback.invoke.apply(callback, args);
        } else {
          callback.invoke();
        }
      } catch (_error) {}
    }
    return custom[event];
  };

  this.Callback = Callback;

}).call(this);
