/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

abstract class EventData extends Transmittable{

  bool _isLocked = false;
  bool get isLocked => _isLocked;
  void lock(){_isLocked = true;}

  void clear(){
    if(_isLocked){
      throw new EventDataLockedError();
    }
    super.clear();
  }

  void set(String name, dynamic value){
    if(_isLocked){
      throw new EventDataLockedError();
    }
    super.set(name, value);
  }
}