local parsonnet = import 'parsonnet.libsonnet';

local b(p) = parsonnet.primitive.builder.new(p) +
             parsonnet.combinator.builder.new(p) +
             parsonnet.char.builder.new(p);

local f = parsonnet.primitive.factory.new(b) +
          parsonnet.combinator.factory.new(b) +
          parsonnet.char.factory.new(b);

local src = std.join('', std.map(std.toString, std.range(1, 1000)));
// local src = 'hello world!';

local s = parsonnet.char.reader.new(src).initState() +
          parsonnet.debug.debugState();

{
  // item: parsonnet.primitive.item(s),
  // result: parsonnet.primitive.result('VALUE')(s),
  // zero: parsonnet.primitive.zero(s),
  // many: parsonnet.combinator.many(parsonnet.primitive.item)(s),

  many: parsonnet.util.writerResultValues(f.item.many.parser(s)),
  // char: f.char('h').parser(s),
  //seq: f.item.seq(f.item.parser).parser(s),
  //   plus: parsonnet.util.outputValues(
  // f
  // .item
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .plus(f.item)
  // .parser(s)
  // ),
}
