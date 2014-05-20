/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _SourceEvent extends _Transmission implements _ISourceEvent{}
abstract class _ISourceEvent{
  _Proxy proxy;
  Transmittable data;
}