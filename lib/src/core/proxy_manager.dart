/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

Map<ObjectId, ProxyManager> _proxyManagers = new Map<ObjectId, ProxyManager>();

class ProxyManager extends Source implements IManager{
  
  final InitAppView _initAppView;
  final Action _onConnectionClose;
  final BiConnection _connection;
  final Map<ObjectId, _Proxy> _proxies = new Map<ObjectId, _Proxy>();
  final Map<ObjectId, int> _proxyConsumptionCount = new Map<ObjectId, int>();
  bool _proxyEventInProgress = false;
  
  ProxyManager(this._initAppView, this._onConnectionClose, this._connection){
    _registerPurityTranTypes();
    _proxyManagers[_purityId] = this;
    _connection.incoming.listen(_receiveString, onError: (_) => shutdown(), onDone: shutdown);
  }
  
  void shutdown(){
    _onConnectionClose();
    _proxyManagers.remove(_purityId);
    _connection.close();
  }
  
  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is _Transmission){
      if(tran is _SourceReady){
        _initAppView(tran.model, this);
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
      v._clientId = _purityId;
      v._sendTran = _sendTran;
      if(!_proxies.containsKey(v._purityId)){
        _proxies[v._purityId] = v;
        _proxyConsumptionCount[v._purityId] = 0;
      }
    }
    return v;
  }
  
  void _sendTran(Transmittable tran){
    _connection.send(tran.toTranString());
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