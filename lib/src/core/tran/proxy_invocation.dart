/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _ProxyInvocation extends _Transmission implements _IProxyInvocation{}
abstract class _IProxyInvocation{
  _Base src;
  Symbol method;
  List<dynamic> posArgs;
  Map<Symbol, dynamic> namArgs;
}