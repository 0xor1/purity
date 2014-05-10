/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

abstract class _Base extends Object with EventEmitter, EventDetector{
  final ObjectId _purityId;
  _Base(this._purityId);
  int get hashCode => _purityId.hashCode;
  bool operator ==(_Base other) => other is _Base && _purityId == other._purityId;
}
