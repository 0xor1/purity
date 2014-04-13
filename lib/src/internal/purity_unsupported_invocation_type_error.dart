/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

class PurityUnsupportedInvocationTypeError{
  String get message => 'Purity models do not support invoking getters or setters.';
  final PurityClientModel model;
  final String property;
  const PurityUnsupportedInvocationTypeError(PurityClientModel this.model, String this.property);
}