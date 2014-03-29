/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Internal;

abstract class ModelBase extends Object with EventEmitter, EventDetector{
  final ObjectId id;
  ModelBase(this.id);
  int get hashCode => id.hashCode;
  bool operator ==(ModelBase other) => id == other.id;
}