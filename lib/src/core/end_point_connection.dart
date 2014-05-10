/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point for a bi-directional [Stream] of [String]s.
 */
class EndPointConnection{
  final Stream<String> _incoming;
  final SendString _send;
  final Action _close;
  
  /**
   * Constructs an [EndPointConnection] instance with:
   * 
   * * [_incoming] as the incoming [Stream] of [String]s.
   * * [_send] to add [String]s to an outgoing [Stream].
   * * [_close] to close the outgoing [Stream] of [String]s.
   *  
   */
  EndPointConnection(this._incoming, this._send, this._close);
}