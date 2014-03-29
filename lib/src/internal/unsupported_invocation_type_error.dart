/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Internal;

class UnsupportedInvocationTypeError{
  String get message => 'Purity models do not support invoking getters or setters.';
  final ClientModel model;
  final String property;
  const UnsupportedInvocationTypeError(ClientModel this.model, String this.property);
}