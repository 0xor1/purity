/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An up-stream [_EndPoint] to route proxy method invocations to their underlying
 * [Model] and pass [Emission]s from all relevant [Model]s down to the connected [ViewEndPoint].
 */
class ModelEndPoint extends _EndPoint{

  Model _seed;
  final SeedApplication _seedApplication;
  final CloseSource _closeSrc;
  final List<Transmittable> _messageQueue = new List<Transmittable>();
  final Map<ObjectId, Model> _srcs = new Map<ObjectId, Model>();
  final int _garbageCollectionFrequency;
  bool _garbageCollectionInProgress = false;
  Timer _garbageCollectionTimer;

  /**
   * Constructs a new [ModelEndPoint] instance with:
   *
   * * [_seedApplication] as the [SeedApplication] function for the application.
   * * [_closeSrc] as the [CloseSource] function for the application.
   * * [_garbageCollectionFrequency] as th number of seconds between garbage collection executions. 0 or null to never run garbage collection.
   * * [connection] as the bi-directional connection to the paired down-stream [ViewEndPoint].
   *
   */
  ModelEndPoint(this._seedApplication, this._closeSrc, this._garbageCollectionFrequency, EndPointConnection connection):
  super(connection){
    _setGarbageCollectionTimer();
    var seed = _seedApplication(this);
    if(seed is Future<Model>){
      seed.then(_processSeed);
    }else if(seed is Model){
      _processSeed(seed);
    }else{
      throw new InvalidInitSourceReturnTypeError(seed);
    }
  }

  void shutdown(){
    ignoreAll();
    if(_garbageCollectionTimer != null){
      _garbageCollectionTimer.cancel();
    }
    var closeSrcVal = _closeSrc(_seed);
    _seed = null;
    if(closeSrcVal is Future){
      closeSrcVal.then((_){
        super.shutdown();
      });
    }else{
      super.shutdown();
    }
  }

  dynamic _preprocessTran(dynamic v){
    if(v is Model){
      if(!_srcs.containsKey(v._purityId)){
        _srcs[v._purityId] = v;
        listen(v, All, (Event<Transmittable> e){
          var srcEvent = new _ModelEvent()
          ..model = v
          ..eventData = e.data;
          if(_garbageCollectionInProgress){
            _messageQueue.add(srcEvent);
          }else{
            _sendTransmittable(srcEvent);
          }
        });
      }
    }
    return v;
  }

  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str);
    if(tran is _GarbageCollectionReport){
      _runGarbageCollectionSequence(tran.models);
    }else if(tran is _ProxyInvocation){
      _srcs[tran.src._purityId]._invoke(tran);
    }else{
      throw new UnsupportedMessageTypeError(tran.runtimeType);
    }
  }

  void _sendTransmittable(Transmittable tran){
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
      _sendTransmittable(new _GarbageCollectionStart());
    });
  }

  void _runGarbageCollectionSequence(Set<Model> proxies){
    proxies.forEach((proxy){
      var src = _srcs.remove(proxy._purityId);
      ignoreEmitter(src);
    });
    for(var i = 0; i < _messageQueue.length; i++){
      _sendTransmittable(_messageQueue[i]);
    }
    _messageQueue.clear();
    _setGarbageCollectionTimer();
  }

  void _processSeed(seed){
    _seed = seed;
    _sendTransmittable(
      new _AppReady()
      ..seed = _seed);
  }
}
