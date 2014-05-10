/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An identifiable source of [Event]s.
 * 
 * It is critical that all public methods on a [Source] always return void.
 * A [Source] should communicate internal state changes with other entities 
 * solely by emitting [Event]s.
 */
class Source extends _Base{
  InstanceMirror _this;
  
  Source():super(new ObjectId()){
    _this = reflect(this);
  }
  
  void _invoke(_ProxyInvocation inv){
    if(_restrictedMethods.contains(inv._method)){
      throw new RestrictedMethodError(inv._method);
    }else{
      _this.invoke(inv._method, inv._posArgs, inv._namArgs);
    }
  }
}