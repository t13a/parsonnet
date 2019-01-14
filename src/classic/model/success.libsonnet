local util = import 'util.libsonnet';

{
  new(out=[], err=[])::
    {
      out: util.toArray(out),
      err: util.toArray(err),

      hasOutput():: std.length(self.out) > 0,
      isSuccess():: true,
    },
}
