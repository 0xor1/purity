/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Thrown when an [SourceEndPoint] or [ProxyEndPoint] doesn't know how to handle a particular type of message.
class UnsupportedMessageTypeError extends Error{
  String get message => 'Purity does not support $type of messages.';
  final Type type;
  UnsupportedMessageTypeError(this.type);
}