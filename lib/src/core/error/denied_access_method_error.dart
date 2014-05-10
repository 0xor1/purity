/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class DeniedAccessMethodError{
  String get message => '$method is a denied access method.';
  final Symbol method;
  DeniedAccessMethodError(this.method);
}