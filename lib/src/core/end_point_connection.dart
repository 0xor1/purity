/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point for a bi-directional [Stream] of [String]s.
 */
class EndPointConnection{
  final Stream<String> incoming;
  final SendString send;
  final Action close;
  
  /**
   * Constructs an [EndPointConnection] instance with:
   * 
   * * [incoming] as the incoming [Stream] of [String]s.
   * * [send] to add [String]s to an outgoing [Stream].
   * * [close] to close the outgoing [Stream] of [String]s.
   *  
   */
  EndPointConnection(this.incoming, this.send, this.close);
}