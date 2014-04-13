/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

@proxy
class PurityClientModel extends PurityModelBase{

  PurityClientModel(ObjectId id):super(id);

  void noSuchMethod(Invocation inv){
    var name = MirrorSystem.getName(inv.memberName);
    if(inv.isMethod){
      var invEvent = new PurityInvocationEvent()
      ..method = inv.memberName
      ..positionalArguments = inv.positionalArguments
      ..namedArguments = inv.namedArguments;
      emitEvent(invEvent);
    }else{
      throw new PurityUnsupportedInvocationTypeError(this, name);
    }
  }


}