{
  new(result=null)::
    if std.isArray(result) then
      result
    else if result != null then
      [result]
    else
      [],
}
