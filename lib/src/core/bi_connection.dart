/**
 * autho: Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class BiConnection{
  final Stream<String> _incoming;
  final SendString _send;
  final Action _close;
  BiConnection(this._incoming, this._send, this._close);
}