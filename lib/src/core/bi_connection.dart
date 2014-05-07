/**
 * autho: Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class BiConnection{
  final Stream<String> incoming;
  final SendString send;
  final Action close;
  BiConnection(this.incoming, this.send, this.close);
}