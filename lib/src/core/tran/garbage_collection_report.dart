/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class GarbageCollectionReport extends Transmission implements IGarbageCollectionReport{}
abstract class IGarbageCollectionReport{
  Set<Proxy> proxies;
}