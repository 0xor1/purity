/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class _ProxyInvocation extends _Transmission implements _IProxyInvocation{}
abstract class _IProxyInvocation{
  _Base _src;
  Symbol _method;
  List<dynamic> _posArgs;
  Map<Symbol, dynamic> _namArgs;
}