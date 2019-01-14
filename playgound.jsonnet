local parsonnet = import 'parsonnet.libsonnet';

local b(p) = parsonnet.primitive.builder(p) +
             parsonnet.combinator.builder(p) +
             parsonnet.char.builder(p);

local f = parsonnet.primitive.factory(b) +
          parsonnet.combinator.factory(b) +
          parsonnet.char.factory(b);

local src = std.join('', std.map(std.toString, std.range(1, 100)));

local s = parsonnet.char.input.new(src).initState() +
          parsonnet.debug.debugState();

{
  //   item: parsonnet.primitive.item(s),
  // result: parsonnet.primitive.result('VALUE')(s),
  // zero: parsonnet.primitive.zero('ERROR')(s),
  // many: parsonnet.combinator.many(parsonnet.primitive.item)(s),

  many: parsonnet.util.outputValues(f.item.many.parser(s)),
  //char: f.char('e').parser(s),
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
