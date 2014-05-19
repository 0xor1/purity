/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class ProxyInvocation extends Transmission implements IProxyInvocation{}
abstract class IProxyInvocation{
  Base src;
  Symbol method;
  List<dynamic> posArgs;
  Map<Symbol, dynamic> namArgs;
}