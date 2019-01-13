local models = import 'models.libsonnet';

{
  local primitive = self,
  local any(x) = true,

  factory(builder):: {
    item(func=any):: builder(primitive.item(func)),
    result(out, err=[]):: builder(primitive.result(out, err)),
    zero(err=[]):: builder(primitive.zero(err)),
  },

  item(func=any)::
    function(state)
      if state.reader().hasItem(state.pos) then
        local item = state.reader().getItem(state.pos);
        if func(item) then
          models.newSuccess(models.newOutput(item, state.next()))
        else
          models.newFailure(
            "unexpected item '%s' found at %s" % [
              std.strReplace(state.reader().formatItem(item), "'", "\\'"),
              state.reader().formatPos(state.pos),
            ]
          )
      else
        models.newFailure('item not found at %s' % state.reader().formatPos(state.pos)),

  result(out, err=[])::
    function(state)
      models.newSuccess(out, err),

  zero(err=[])::
    function(state)
      models.newFailure(err),
}
