/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class DuplicatedPurityModelIdentifierError extends DuplicatedTranAnnotationIdentifierError{
  DuplicatedPurityModelIdentifierError(String fullNamespace, String identifier): super(fullNamespace, identifier);
}