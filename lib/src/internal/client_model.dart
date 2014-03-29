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
      ..method = name
      ..positionalArguments = inv.positionalArguments
      ..namedArguments = new Map<String, dynamic>.fromIterable(
        inv.namedArguments.keys,
        key: (k) => MirrorSystem.getName(k),
        value: (k) => inv.namedArguments[k]);
      emitEvent(invEvent);
    }else{
      throw new UnsupportedInvocationTypeError(this, name);
    }
  }


}