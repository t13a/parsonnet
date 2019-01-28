local parsonnet = import 'parsonnet.libsonnet';

local b(p) = parsonnet.primitive.builder.new(p) +
             parsonnet.combinator.builder.new(p) +
             parsonnet.char.builder.new(p);

local f = parsonnet.primitive.factory.new(b) +
          parsonnet.combinator.factory.new(b) +
          parsonnet.char.factory.new(b);

// local s(src) = parsonnet.char.input.new(src).initState() +
//                parsonnet.debug.debugState();
local s(src) = parsonnet.char.input.new(src).initState();

// http://book.realworldhaskell.org/read/using-parsec.html
local csv = {
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
};

{
  local v(a) = parsonnet.util.outputResultValues(a),
  // test1: v(csv.quotedChar.many.parser(s('""hello'))),
  // test2: v(csv.quotedCell.many.parser(s('"hello,world"'))),
  // test3: v(csv.cell.parser(s('"hello world", hello world'))),
  // test4: v(csv.cell.parser(s('hello,world'))),
  // test5: v(csv.line.parser(s('hello,world,"every,one"'))),
  //test7: csv.csvFile.parser(s('aaa,bbb,"ccc,ddd"\neee,fff\n')),
  testCsv:
    local src = |||
      "Product","Price"
      "O'Reilly Socks",10
      "Shirt with ""Haskell"" text",20
      "Shirt, ""O'Reilly"" version",20
      "Haskell Caps",15
    |||;
    v(csv.csvFile.parser(s(src))),
}
