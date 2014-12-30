/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class DuplicatedPurityMethodIdentifierError extends Error{
  String get message => 'Model type "$modelType" already contains a purity method with identifier "$methodIdentifier"';
  final Type modelType;
  final methodIdentifier;
  DuplicatedPurityMethodIdentifierError(this.modelType, this.methodIdentifier);
}