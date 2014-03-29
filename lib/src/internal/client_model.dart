/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of Internal;

@proxy
class ClientModel extends ModelBase{

  ClientModel(ObjectId id):super(id);

  void noSuchMethod(Invocation inv){
    var name = MirrorSystem.getName(inv.memberName);
    if(inv.isMethod){
      var invEvent = new InvocationEvent()
      ..method = inv.memberName
      ..positionalArguments = inv.positionalArguments
      ..namedArguments = inv.namedArguments;
      emitEvent(invEvent);
    }else{
      throw new UnsupportedInvocationTypeError(this, name);
    }
  }


}