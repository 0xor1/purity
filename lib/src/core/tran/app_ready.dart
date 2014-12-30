/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _AppReady extends _Transmission{
  Model get seed => get('seed');
  void set seed (Model o){set('seed', o);}
}