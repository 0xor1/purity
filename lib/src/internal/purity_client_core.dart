/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

Map<ObjectId, PurityClientCore> _clientCores = new Map<ObjectId, PurityClientCore>();

class PurityClientCore extends PurityModel{

  final String name;
  final InitAppView _initAppView;
  final Action _onConnectionClose;
  final Stream<String> _incoming;
  final SendString _sendString;
  final Action _closeStream;
  final Map<ObjectId, PurityClientModel> _models = new Map<ObjectId, PurityClientModel>();
  final Map<ObjectId, int> _modelConsumption = new Map<ObjectId, int>();
  bool _modelEventInProgress = false;
  
  PurityClientCore(this.name, this._initAppView, this._onConnectionClose, this._incoming, this._sendString, this._closeStream){
    _registerPurityTranTypes();
    _clientCores[_purityId] = this;
    _incoming.listen(_receiveString, onError: (_) => shutdown(), onDone: shutdown);
  }
  
  void shutdown(){
    _onConnectionClose();
    _closeStream();
  }
  
  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is PurityTransmission){
      if(tran is PurityAppSessionInitialisedTransmission){
        _initAppView(tran.model, this);
      }else if(tran is PurityGarbageCollectionStartTransmission){
        _runGarbageCollectionSequence();
      }
    }else if(tran is PurityEvent){
      _modelEventInProgress = true;
      _models[tran.emitter._purityId].emitEvent(tran).then((_){ _modelEventInProgress = false; });
    }
  }
  
  dynamic _postprocessTran(dynamic v){
    if(v is PurityClientModel){
      v._clientId = _purityId;
      v._sendTran = _sendTran;
      if(!_models.containsKey(v._purityId)){
        _models[v._purityId] = v;
        _modelConsumption[v._purityId] = 0;
      }
    }
    return v;
  }
  
  void _sendTran(Transmittable tran){
    _sendString(tran.toTranString());
  }
  
  void _runGarbageCollectionSequence(){
    if(_modelEventInProgress){
      new Future.delayed(new Duration(), _runGarbageCollectionSequence);
      return;
    }else{
      var modelsCollected = new Set<PurityModelBase>();
      _modelConsumption.forEach((_purityId, usageCount){
        if(usageCount == 0){
          var model = _models.remove(_purityId);
          ignoreAllEventsFrom(model);
          modelsCollected.add(model);
        }
      });
      modelsCollected.forEach((model){
        _modelConsumption.remove(model._purityId);
      });
      _sendTran(new PurityGarbageCollectionReportTransmission()..models = modelsCollected);
    }
  }
}