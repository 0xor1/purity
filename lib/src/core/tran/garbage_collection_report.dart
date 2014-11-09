/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _GarbageCollectionReport extends _Transmission{
  Set<_Proxy> get proxies => get('proxies');
  void set proxies (Set<_Proxy> o) => set('proxies', o);
}