/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * A down-stream [EndPoint] to route [Event]s from [Source]s to their proxies for re-emitting to any listening [Consumer]s.
 */
class ProxyEndPoint extends EndPoint{
  final InitConsumer _initConsumption;
  final Action _onConnectionClose;
  final Map<ObjectId, Proxy> _proxies = new Map<ObjectId, Proxy>();
  bool _proxyEventInProgress = false;

  ProxyEndPoint(this._initConsumption, this._onConnectionClose, EndPointConnection connection):
    super(connection){
    open(_receiveString);
  }

  void shutdown(){
    _onConnectionClose();
    super.shutdown();
  }

  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is Transmission){
      if(tran is SourceReady){
        _initConsumption(tran.src, this);
      }else if(tran is GarbageCollectionStart){
        _runGarbageCollectionSequence();
      }else if(tran is SourceEvent){
        _proxyEventInProgress = true;
        _proxies[tran.proxy.purityId].emitEvent(tran.data).then((_){ _proxyEventInProgress = false; });
      }
    }else{
      throw new UnsupportedMessageTypeError(reflect(tran).type.reflectedType);
    }
  }

  dynamic _postprocessTran(dynamic v){
    if(v is Proxy){
      v.sendTran = _sendTran;
      if(!_proxies.containsKey(v.purityId)){
        _proxies[v.purityId] = v;
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
      var proxiesCollected = new Set<Proxy>();
      _proxies.forEach((purityId, proxy){
        if(proxy._usageCount == 0){
          proxiesCollected.add(proxy);
        }
      });
      proxiesCollected.forEach((proxy){
        _proxies.remove(proxy.purityId);
      });
      _sendTran(new GarbageCollectionReport()..proxies = proxiesCollected);
    }
  }
}