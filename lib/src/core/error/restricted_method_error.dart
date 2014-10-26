/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Thrown when a [Source] attempts to invoke a method which is designated as having restricted access.
class RestrictedMethodError extends Error{
  String get message => '$method is a restricted access method.';
  final Symbol method;
  RestrictedMethodError(this.method);
}