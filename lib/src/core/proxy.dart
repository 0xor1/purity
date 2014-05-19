/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

@proxy
class Proxy extends Base{

  int _usageCount;
  SendTran _send;
  
  Proxy(ObjectId id):super(id){
    _usageCount = 0;
  }

  void noSuchMethod(Invocation inv){
    if(inv.isMethod){
      var invTran = new ProxyInvocation()
      ..method = inv.memberName
      ..posArgs = inv.positionalArguments
      ..namArgs = inv.namedArguments
      ..src = this;
      _send(invTran);
    }else{
      var name = MirrorSystem.getName(inv.memberName);
      throw new UnsupportedProxyInvocationError(this, name);
    }
  }

}