/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An identifiable source of [Emission]s.
 *
 * It is critical that all public methods on a [Source] always return void.
 * A [Source] should communicate internal state changes with other entities
 * solely by emitting objects.
 */
class Source extends _Base{

  static final Set<Symbol> _restrictedMethods = new Set<Symbol>()
  ..addAll([
    #emit,
    #on,
    #once,
    #off,
    #listen,
    #listenOnce,
    #ignoreTypeFromEmitter,
    #ignoreType,
    #ignoreEmitter,
    #ignoreAll
  ]);

  InstanceMirror _this;

  Source():super(new ObjectId());

  void _invoke(_ProxyInvocation inv){
    if(_this == null){
      _this = reflect(this);
    }
    if(_restrictedMethods.contains(inv.method) || MirrorSystem.getName(inv.method).startsWith('_')){
      throw new RestrictedMethodError(inv.method);
    }else{
      _this.invoke(inv.method, inv.posArgs, inv.namArgs);
    }
  }

  Future<Emission<Transmittable>> emit(Transmittable data){
    data.lock();
    return super.emit(data);
  }
}