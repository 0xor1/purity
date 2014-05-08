/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class SourceManager extends Source implements IManager{
  
  Source _rootSrc;
  final InitSource _initSrc;
  final CloseSource _closeSrc;
  final BiConnection _connection;
  final List<Transmittable> _messageQueue = new List<Transmittable>();
  final Map<ObjectId, Source> _srcs = new Map<ObjectId, Source>();
  final int _garbageCollectionFrequency; //in seconds
  bool _garbageCollectionInProgress = false;
  Timer _garbageCollectionTimer;

  SourceManager(this._initSrc, this._closeSrc, this._connection, this._garbageCollectionFrequency){
    _registerPurityCoreTranTypes();
    _setGarbageCollectionTimer();
    _connection._incoming.listen(_receiveString, onDone: shutdown, onError: (error) => shutdown());
    _initSrc(this).then((src){
      _rootSrc = src;
      _sendTran(
        new _Ready()
        .._src = src);
    });
  }
  
  void shutdown(){
    ignoreAllEvents();
    if(_garbageCollectionTimer != null){
      _garbageCollectionTimer.cancel();
    }
    _closeSrc(_rootSrc).then((_){
      _connection._close(); 
      emitEvent(new ShutdownEvent());     
    });
  }

  dynamic _preprocessTran(dynamic v){
    if(v is Source){
      if(!_srcs.containsKey(v._purityId)){
        _srcs[v._purityId] = v;
        listen(v, Omni, (Event e){
          if(_garbageCollectionInProgress){
            _messageQueue.add(e);
          }else{
            _sendTran(e);
          }
        });
      }
      return new _Proxy(v._purityId);
    }
    return v;
  }

  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str);
    if(tran is _GarbageCollectionReport){
      _runGarbageCollectionSequence(tran.models);
    }else if(tran is _ProxyInvocation){
      var modelMirror = reflect(_srcs[(tran.model as _Base)._purityId]);
      try{
        modelMirror.invoke(tran.method, tran.posArgs, tran.namArgs);
      }catch(e){
        //emitEvent(new NoSuchMethodException());
      }
    }else{
      throw new UnsupportedMessageTypeError(reflect(tran).type.reflectedType);
    }
  }
  
  void _sendTran(Transmittable tran){
    _connection._send(tran.toTranString(_preprocessTran));
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
      _sendTran(new _GarbageCollectionStart());
    });
  }
  
  void _runGarbageCollectionSequence(Set<_Base> srcs){
    srcs.forEach((src){
      _srcs.remove(src._purityId);
    });
    for(var i = 0; i < _messageQueue.length; i++){
      _sendTran(_messageQueue[i]);
    }
    _messageQueue.clear();
    _setGarbageCollectionTimer();
  }
}
