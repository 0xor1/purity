/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An up-stream [EndPoint] to route proxy method invocations to their underlying
 * [Source] and pass [Event]s from all relevant [Source]s down to the connected [ProxyEndPoint].
 */
class SourceEndPoint extends EndPoint{

  Source _rootSrc;
  final InitSource _initSrc;
  final CloseSource _closeSrc;
  final List<Transmittable> _messageQueue = new List<Transmittable>();
  final Map<ObjectId, Source> _srcs = new Map<ObjectId, Source>();
  final int _garbageCollectionFrequency;
  bool _garbageCollectionInProgress = false;
  Timer _garbageCollectionTimer;

  /**
   * Constructs a new [SourceEndPoint] instance with:
   *
   * * [_initSrc] as the [InitSource] function for the application.
   * * [_closeSrc] as the [CloseSource] function for the application.
   * * [_garbageCollectionFrequency] as th number of seconds between garbage collection executions. 0 or null to never run garbage collection.
   * * [connection] as the bi-directional connection to the paired down-stream [ProxyEndPoint].
   *
   */
  SourceEndPoint(this._initSrc, this._closeSrc, this._garbageCollectionFrequency, EndPointConnection connection):
  super(connection){
    _registerCoreRestrictedMethods();
    _setGarbageCollectionTimer();
    _initSrc(this).then((src){
      _rootSrc = src;
      _sendTran(
        new SourceReady()
        ..src = src);
    });
  }

  void shutdown(){
    ignoreAllEvents();
    if(_garbageCollectionTimer != null){
      _garbageCollectionTimer.cancel();
    }
    _closeSrc(_rootSrc).then((_){
      super.shutdown();
    });
  }

  dynamic _preprocessTran(dynamic v){
    if(v is Source){
      if(!_srcs.containsKey(v.purityId)){
        _srcs[v.purityId] = v;
        listen(v, Omni, (Event<Transmittable> e){
          var srcEvent = new SourceEvent()
          ..proxy = e.emitter
          ..data = e.data;
          if(_garbageCollectionInProgress){
            _messageQueue.add(srcEvent);
          }else{
            _sendTran(srcEvent);
          }
        });
      }
      return new Proxy(v.purityId);
    }
    return v;
  }

  void receiveString(String str){
    var tran = new Transmittable.fromTranString(str);
    if(tran is GarbageCollectionReport){
      _runGarbageCollectionSequence(tran._proxies);
    }else if(tran is ProxyInvocation){
      _srcs[tran.src.purityId].invoke(tran);
    }else{
      throw new UnsupportedMessageTypeError(reflect(tran).type.reflectedType);
    }
  }

  void _sendTran(Transmittable tran){
    _connection.send(tran.toTranString(_preprocessTran));
  }

  void _setGarbageCollectionTimer(){
    if(_garbageCollectionTimer != null){
      _garbageCollectionTimer.cancel();
    }
    _garbageCollectionInProgress = false;
    if(_garbageCollectionFrequency == 0 || _garbageCollectionFrequency == null){
      return;
    }
    _garbageCollectionTimer = new Timer(new Duration(seconds: _garbageCollectionFrequency), (){
      _garbageCollectionInProgress = true;
      _sendTran(new GarbageCollectionStart());
    });
  }

  void _runGarbageCollectionSequence(Set<Proxy> proxies){
    proxies.forEach((proxy){
      var src = _srcs.remove(proxy.purityId);
      ignoreAllEventsFrom(src);
    });
    for(var i = 0; i < _messageQueue.length; i++){
      _sendTran(_messageQueue[i]);
    }
    _messageQueue.clear();
    _setGarbageCollectionTimer();
  }
}
