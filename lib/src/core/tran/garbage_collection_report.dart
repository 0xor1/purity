/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _GarbageCollectionReport extends _Transmission implements _IGarbageCollectionReport{}
abstract class _IGarbageCollectionReport{
  Set<_Proxy> proxies;
}