/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _GarbageCollectionReport extends _Transmission{
  Set<Model> get models => get('models');
  void set models (Set<Model> o){set('models', o);}
}