/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _GarbageCollectionReport extends _Transmission{
  Set<Source> get proxies => get('proxies');
  void set proxies (Set<Source> o) => set('proxies', o);
}