/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class UnsupportedMessageTypeError{
  String get message => 'Purity does not support $type of messages.';
  final Type type;
  const UnsupportedMessageTypeError(this.type);
}