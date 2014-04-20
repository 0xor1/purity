/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

@proxy
class PurityClientModel extends PurityModelBase{

  ObjectId _clientId;
  
  PurityClientModel(ObjectId id):super(id);

  void noSuchMethod(Invocation inv){
    var name = MirrorSystem.getName(inv.memberName);
    if(inv.isMethod){
      var invEvent = new PurityInvocationEvent()
      ..method = inv.memberName
      ..posArgs = inv.positionalArguments
      ..namArgs = inv.namedArguments;
      emitEvent(invEvent);
    }else{
      throw new PurityUnsupportedInvocationTypeError(this, name);
    }
  }

}