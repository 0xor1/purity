/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityUnsupportedMessageTypeError{
  String get message => 'Purity does not support $type of messages.';
  final Type type;
  const PurityUnsupportedMessageTypeError(Type this.type);
}