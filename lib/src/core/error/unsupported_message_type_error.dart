/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Thrown when an [_EndPoint] doesn't know how to handle a particular type of message.
 */
class UnsupportedMessageTypeError{
  String get message => 'Purity does not support $type of messages.';
  final Type type;
  const UnsupportedMessageTypeError(this.type);
}