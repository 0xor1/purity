/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

abstract class PurityModelBase extends Object with EventEmitter, EventDetector{
  final ObjectId purityId;
  PurityModelBase(this.purityId);
  int get hashCode => purityId.hashCode;
  bool operator ==(PurityModelBase other) => purityId == other.purityId;
}