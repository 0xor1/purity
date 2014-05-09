/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class ProxyManager extends Source implements IManager{
  
  final InitConsumption _initProxy;
  final Action _onConnectionClose;
  final BiConnection _connection;
  final Map<ObjectId, _Proxy> _proxies = new Map<ObjectId, _Proxy>();
  final Map<ObjectId, int> _proxyConsumptionCount = new Map<ObjectId, int>();
  bool _proxyEventInProgress = false;
  
  ProxyManager(this._initProxy, this._onConnectionClose, this._connection){
    _registerPurityCoreTranTypes();
    _connection._incoming.listen(_receiveString, onError: (_) => shutdown(), onDone: shutdown);
  }
  
  void shutdown(){
    _onConnectionClose();
    emitEvent(new ShutdownEvent());
    _connection._close();
  }
  
  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is _Transmission){
      if(tran is _Ready){
        _initProxy(tran.model, this);
      }else if(tran is _GarbageCollectionStart){
        _runGarbageCollectionSequence();
      }
    }else if(tran is Event){
      _proxyEventInProgress = true;
      _proxies[tran.emitter._purityId].emitEvent(tran).then((_){ _proxyEventInProgress = false; });
    }else{
      throw new UnsupportedMessageTypeError(reflect(tran).type.reflectedType);
    }
  }
  
  dynamic _postprocessTran(dynamic v){
    if(v is _Proxy){
      v._proxyConsumptionCount = _proxyConsumptionCount;
      v._send = _sendTran;
      if(!_proxies.containsKey(v._purityId)){
        _proxies[v._purityId] = v;
        _proxyConsumptionCount[v._purityId] = 0;
      }
    }
    return v;
  }
  
  void _sendTran(Transmittable tran){
    _connection._send(tran.toTranString());
  }
  
  void _runGarbageCollectionSequence(){
    if(_proxyEventInProgress){
      new Future.delayed(new Duration(), _runGarbageCollectionSequence);
      return;
    }else{
      var srcsCollected = new Set<_Base>();
      _proxyConsumptionCount.forEach((_purityId, usageCount){
        if(usageCount == 0){
          var src = _proxies.remove(_purityId);
          ignoreAllEventsFrom(src);
          srcsCollected.add(src);
        }
      });
      srcsCollected.forEach((src){
        _proxyConsumptionCount.remove(src._purityId);
      });
      _sendTran(new _GarbageCollectionReport().._srcs = srcsCollected);
    }
  }
}