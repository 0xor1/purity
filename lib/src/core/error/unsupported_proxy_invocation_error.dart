/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Thrown when a [Consumer] attempts to call a getter or setter on a [_Proxy]
 */
class UnsupportedProxyInvocationError{
  String get message => 'Purity proxy event sources do not support invoking getters or setters.';
  final _Proxy source;
  final String property;
  const UnsupportedProxyInvocationError(this.source, this.property);
}