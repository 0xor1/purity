/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Thrown if the InitSource function passed in to the [ServerCore] constructor does not return a [Model] or [Future<Source>].
class InvalidInitSourceReturnTypeError extends Error{
  String get message => 'Error the InitSource function must only return a Source or Future<Source>.';
  final dynamic initSourceValue;
  InvalidInitSourceReturnTypeError(this.initSourceValue);
}