/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Thrown when a [Consumer] attempts to call a getter or setter on a [_Proxy]
class UnsupportedProxyInvocationError extends Error{
  String get message => 'Purity proxy event sources do not support invoking getters or setters.';
  final Source source;
  final String property;
  UnsupportedProxyInvocationError(this.source, this.property);
}