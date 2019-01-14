local util = import 'util.libsonnet';

{
  new(err=[])::
    {
      err: util.toArray(err),

      hasOutput():: false,
      isSuccess():: false,
    },
}
