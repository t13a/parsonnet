local parsonnet = import 'parsonnet.libsonnet';

local b(p) = parsonnet.primitive.builder.new(p) +
             parsonnet.combinator.builder.new(p) +
             parsonnet.char.builder.new(p);

local f = parsonnet.primitive.factory.new(b) +
          parsonnet.combinator.factory.new(b) +
          parsonnet.char.factory.new(b);

// http://book.realworldhaskell.org/read/using-parsec.html
{
  csvFile:: f.endBy(self.line, self.eol),
  line:: f.sepBy(self.cell, f.char(',')),

  cell::
    f
    .plus(self.quotedCell, f.many(f.noneOf('",\n\r')))
    .bind(function(a) f.result(std.join('', a.value))),

  quotedCell::
    f.bind(
      f.char('"'),
      function(a)
        f.bind(
          f.many(self.quotedChar),
          function(b)
            f.bind(
              f.char('"').plus(f.fail('quote at end of cell')),
              function(c)
                f.result(b.value)
            )
        )
    ),

  quotedChar::
    f
    .bind(f.string('""'), function(a) f.result('"'))
    .plus(f.noneOf('"')),

  eol::
    f
    .string('\n\r')
    .plus(f.string('\r\n'))
    .plus(f.string('\n'))
    .plus(f.string('\n'))
    .plus(f.fail('end of line')),
}
