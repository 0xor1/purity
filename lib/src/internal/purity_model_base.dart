/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

abstract class PurityModelBase extends Object with EventEmitter, EventDetector{
  final ObjectId _purityId;
  PurityModelBase(this._purityId);
  int get hashCode => _purityId.hashCode;
  bool operator ==(PurityModelBase other) => _purityId == other._purityId;
}