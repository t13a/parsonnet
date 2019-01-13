local utils = import 'utils.libsonnet';

{
  local models = self,

  newReader():: {
    initPos():: error 'not implemented yet',
    nextPos(pos):: error 'not implemented yet',

    hasItem(pos):: error 'not implemented yet',
    getItem(pos):: error 'not implemented yet',

    formatPos(pos):: std.toString(pos),
    formatItem(item):: std.toString(item),
  },

  newState(reader):: {
    pos: self.reader().initPos(),

    next():: self { pos: reader.nextPos(super.pos) },
    reader():: reader,
  },

  newSuccess(out=[], err=[])::
    local o = utils.toArray(out);
    local e = utils.toArray(err);
    assert std.length(std.filter(self.isOutput, o)) == std.length(o) : 'out must be a output';
    assert std.length(std.filter(std.isString, e)) == std.length(e) : 'err must be a string';
    {
      out: o,
      err: e,

      hasConsumption():: std.length(self.out) > 0,
      isSuccess():: true,
    },

  newFailure(err=[])::
    local e = utils.toArray(err);
    assert std.length(std.filter(std.isString, e)) == std.length(e) : 'err must be a string';
    {
      err: e,

      hasConsumption():: false,
      isSuccess():: false,
    },

  newOutput(value, state)::
    assert value != null : 'value must not be null';
    assert std.isObject(state) : 'state must be an object, got %s' % std.type(state);
    assert self.isState(state) : 'state must be a valid fields, got %s' % std.join(', ', std.objectFields(state));
    {
      value: value,
      state: state,
    },

  isState(x)::
    std.isObject(x) &&
    std.objectHas(x, 'pos') &&
    std.objectHasAll(x, 'next') &&
    std.objectHasAll(x, 'reader'),

  isResult(x)::
    std.isObject(x) &&
    std.objectHas(x, 'err') &&
    std.objectHasAll(x, 'hasConsumption') &&
    std.objectHasAll(x, 'isSuccess'),

  isSuccess(x)::
    self.isResult(x) &&
    std.objectHas(x, 'out') &&
    x.isSuccess(),

  isFailure(x)::
    self.isResult(x) &&
    !x.isSuccess(),

  isOutput(x)::
    std.isObject(x) &&
    std.objectHas(x, 'value') &&
    std.objectHas(x, 'state'),

  filterSuccess(arr)::
    std.filter(self.isSuccess, arr),

  filterFailure(arr)::
    std.filter(self.isFailure, arr),
}
