/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _SourceReady extends _Transmission{
  Source get seed => get('seed');
  void set seed (Source o) => set('seed', o);
}