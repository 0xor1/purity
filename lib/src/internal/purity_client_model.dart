/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

@proxy
class PurityClientModel extends PurityModelBase{

  ObjectId _clientId;
  SendTran _sendTran;
  
  PurityClientModel(ObjectId id):super(id);

  void noSuchMethod(Invocation inv){
    if(inv.isMethod){
      var invTran = new PurityInvocationTransmission()
      ..method = inv.memberName
      ..posArgs = inv.positionalArguments
      ..namArgs = inv.namedArguments
      ..model = this;
      _sendTran(invTran);
    }else{
      var name = MirrorSystem.getName(inv.memberName);
      throw new PurityUnsupportedInvocationTypeError(this, name);
    }
  }

}