{
  array:: {
    head(arr)::
      assert std.isArray(arr) : 'arr must be an array, got %s' % std.type(arr);
      if std.length(arr) > 0 then
        arr[0]
      else
        null,

    tail(arr)::
      assert std.isArray(arr) : 'arr must be an array, got %s' % std.type(arr);
      if std.length(arr) > 1 then
        arr[1:std.length(arr)]
      else
        [],
  },

  result:: {
    failures(results)::
      std.filter(self.pred.failure, results),

    failuresOrSuccesses(results)::
      local s = self.successes(results);
      local f = self.failures(results);
      if std.length(f) > 0 then f else s,

    successes(results)::
      std.filter(self.pred.success, results),

    successesOrFailures(results)::
      local s = self.successes(results);
      local f = self.failures(results);
      if std.length(s) > 0 then s else f,

    pred: {
      failure(result)::
        assert std.isObject(result) : 'result must be an object, got %s' % std.type(result);
        !result.isSuccess(),

      /*
       * The array of result is assumed as follows:
       *
       * - Success results and failure results are not mixed in one array.
       * - An array on success may not contain anything.
       * - An array on failure contains at least one result.
       */
      failures(results)::
        assert std.isArray(results) : 'results must be an array, got %s' % std.type(results);
        std.length(results) > 0 && !results[0].isSuccess(),

      success(result)::
        assert std.isObject(result) : 'result must be an object, got %s' % std.type(result);
        result.isSuccess(),

      successes(results)::
        !self.failures(results),
    },
  },
}
