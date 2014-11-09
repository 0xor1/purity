/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _SourceReady extends _Transmission{
  _Base get seed => get('seed');
  void set seed (_Base o) => set('seed', o);
}