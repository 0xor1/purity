/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * A down-stream [_EndPoint] to route [Event]s from [Source]s to their proxies for re-emitting to any listening [Consumer]s.
 */
class ProxyEndPoint extends _EndPoint{
  final InitConsumer _initConsumption;
  final Action _onConnectionClose;
  final Map<ObjectId, Source> _proxies = new Map<ObjectId, Source>();
  bool _proxyEventInProgress = false;

  ProxyEndPoint(this._initConsumption, this._onConnectionClose, EndPointConnection connection):
    super(connection){
  }

  void shutdown(){
    _onConnectionClose();
    super.shutdown();
  }

  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is _Transmission){
      if(tran is _SourceReady){
        _initConsumption(tran.seed, this);
      }else if(tran is _GarbageCollectionStart){
        _runGarbageCollectionSequence();
      }else if(tran is _SourceEvent){
        _proxyEventInProgress = true;
        _proxies[tran.proxy._purityId].emit(tran.data).then((_){ _proxyEventInProgress = false; });
      }
    }else{
      throw new UnsupportedMessageTypeError(tran.runtimeType);
    }
  }

  dynamic _postprocessTran(dynamic v){
    if(v is Source){
      if(!_proxies.containsKey(v._purityId)){
        v._sendTran = _sendTransmittable;
        _proxies[v._purityId] = v;
      }else{
        return _proxies[v._purityId];
      }
    }
    return v;
  }

  void _sendTransmittable(Transmittable tran){
    _connection.send(tran.toTranString());
  }

  void _runGarbageCollectionSequence(){
    if(_proxyEventInProgress){
      new Future.delayed(new Duration(), _runGarbageCollectionSequence);
      return;
    }else{
      var proxiesCollected = new Set<Source>();
      _proxies.forEach((purityId, proxy){
        if(proxy._usageCount == 0){
          proxiesCollected.add(proxy);
        }
      });
      proxiesCollected.forEach((proxy){
        _proxies.remove(proxy._purityId);
      });
      _sendTransmittable(new _GarbageCollectionReport()..proxies = proxiesCollected);
    }
  }
}