/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

@proxy
class _Proxy extends _Base{

  Map<ObjectId, int> _proxyConsumptionCount;
  SendTran _send;
  
  _Proxy(ObjectId id):super(id);

  void noSuchMethod(Invocation inv){
    if(inv.isMethod){
      var invTran = new _ProxyInvocation()
      .._method = inv.memberName
      .._posArgs = inv.positionalArguments
      .._namArgs = inv.namedArguments
      .._src = this;
      _send(invTran);
    }else{
      var name = MirrorSystem.getName(inv.memberName);
      throw new UnsupportedProxyInvocationError(this, name);
    }
  }

}