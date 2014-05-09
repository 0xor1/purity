/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class UnsupportedProxyInvocationError{
  String get message => 'Purity proxy event sources do not support invoking getters or setters.';
  final _Proxy source;
  final String property;
  const UnsupportedProxyInvocationError(this.source, this.property);
}