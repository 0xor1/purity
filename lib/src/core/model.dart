/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An identifiable source of [Event]s.
 *
 * It is critical that all public methods on a [Model] always return void.
 * A [Model] should communicate internal state changes with other entities
 * solely by emitting events.
 */
abstract class Model extends Object with Emitter, Receiver{

  ObjectId _purityId;
  int get hashCode => _purityId.hashCode;
  bool operator ==(other) => other is Model && _purityId == other._purityId;

  ///proxy members
  bool _isProxy;
  int _usageCount = 0;
  SendTran _sendTran;
  InstanceMirror _self;

  Model(): this._purityId = new ObjectId(), _isProxy = false;

  void _invoke(_ProxyInvocation inv){
    if(_self == null){
      _self = reflect(this);
    }
    var invoInfo = _invocationInfoMapping[this.runtimeType][inv.method];
    var mappedNamArgs;
    if(inv.namArgs != null){
      mappedNamArgs = new Map<Symbol, dynamic>();
      inv.namArgs.forEach((id, val){
        mappedNamArgs[invoInfo.namArgs[id]] = val;
      });
    }
    if(inv.posArgs == null) inv.posArgs = [];
    _self.invoke(invoInfo.methodName, inv.posArgs, mappedNamArgs);
  }

  Future<Event<EventData>> emit(EventData data){
    data.lock();
    return super.emit(data);
  }

  void _callSource(String method, List<dynamic> posArgs, Map<String, dynamic> namArgs){
    var proxyInv = new _ProxyInvocation()
    ..method = method
    ..posArgs = posArgs
    ..namArgs = namArgs
    ..src = this;
    _sendTran(proxyInv);
  }

  void method(String name, Function actual, [List<dynamic> posArgs = null, Map<Symbol, dynamic> namArgs = null]){
    if(_isProxy){
      var mappedNamArgs;
      if(namArgs != null){
        mappedNamArgs = new Map<String, dynamic>();
        _invocationInfoMapping[runtimeType][name].namArgs.forEach((id, sym){
          if(namArgs.containsKey(sym)){
            mappedNamArgs[id] = namArgs[sym];
          }
        });
      }
      _callSource(name, posArgs, mappedNamArgs);
    }else{
      if(posArgs == null) posArgs = [];
      Function.apply(actual, posArgs, namArgs);
    }
  }
}