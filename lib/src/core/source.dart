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
@proxy
class Source extends Object with Emitter, Receiver{

  final ObjectId _purityId;
  int get hashCode => _purityId.hashCode;
  bool operator ==(other) => other is Source && _purityId == other._purityId;
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

  Source(): this._purityId = new ObjectId(), _isProxy = true;

  void _invoke(_ProxyInvocation inv){
    if(_this == null){
      _this = reflect(this);
    }
    if(_restrictedMethods.contains(inv.method)){
      throw new RestrictedMethodError(inv.method);
    }else{
      _this.invoke(inv.method, inv.posArgs, inv.namArgs);
    }
  }

  Future<Event<Transmittable>> emit(Transmittable data){
    data.lock();
    return super.emit(data);
  }

  ///proxy members
  final bool _isProxy;
  int _usageCount = 0;
  SendTran _sendTran;

  Source._proxy(this._purityId): _isProxy = true;

  void noSuchMethod(Invocation inv){
    if(this._isProxy){
      if(inv.isMethod){
        var invTran = new _ProxyInvocation()
        ..method = inv.memberName
        ..posArgs = inv.positionalArguments
        ..namArgs = inv.namedArguments
        ..src = this;
        _sendTran(invTran);
      }else{
        var name = MirrorSystem.getName(inv.memberName);
        throw new UnsupportedProxyInvocationError(this, name);
      }
    }else{
      return super.noSuchMethod(inv);
    }
  }
}