/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * A down-stream [_EndPoint] to route [Event]s from [Model]s to any listening [View]s.
 */
class ViewEndPoint extends _EndPoint{
  final InitConsumer _initConsumption;
  final Action _onConnectionClose;
  final Map<ObjectId, Model> _proxies = new Map<ObjectId, Model>();
  bool _proxyEventInProgress = false;

  ViewEndPoint(this._initConsumption, EndPointConnection connection, [this._onConnectionClose = null]):
    super(connection){
  }

  void shutdown(){
    if(_onConnectionClose != null){
      _onConnectionClose();
    }
    super.shutdown();
  }

  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is _Transmission){
      if(tran is _AppReady){
        _initConsumption(tran.seed, this);
      }else if(tran is _GarbageCollectionStart){
        _runGarbageCollectionSequence();
      }else if(tran is _ModelEvent){
        _proxyEventInProgress = true;
        _proxies[tran.model._purityId].emit(tran.eventData).then((_){ _proxyEventInProgress = false; });
      }
    }else{
      throw new UnsupportedMessageTypeError(tran.runtimeType);
    }
  }

  dynamic _postprocessTran(dynamic v){
    if(v is Model){
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
      var proxiesCollected = new Set<Model>();
      _proxies.forEach((purityId, proxy){
        if(proxy._usageCount == 0){
          proxiesCollected.add(proxy);
        }
      });
      proxiesCollected.forEach((proxy){
        _proxies.remove(proxy._purityId);
      });
      _sendTransmittable(new _GarbageCollectionReport()..models = proxiesCollected);
    }
  }
}