{
  local model = self,

  input:: import 'model/input.libsonnet';
  state:: import 'model/state.libsonnet';
  success:: import 'model/success.libsonnet';
  failure:: import 'model/failure.libsonnet';
  output:: import 'model/output.libsonnet';
  util:: import 'model/util.libsonnet';

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
