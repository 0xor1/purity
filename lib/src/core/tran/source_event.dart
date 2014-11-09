/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _SourceEvent extends _Transmission{
  _Base get proxy => get('proxy');
  void set proxy (_Proxy o) => set('proxy', o);
  Transmittable get data => get('data');
  void set data (Transmittable o) => set('data', o);
}