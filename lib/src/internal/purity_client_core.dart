/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

Map<ObjectId, int> _modelConsumption = new Map<ObjectId, int>();

class PurityClientCore extends PurityModel{

  final InitAppView _initAppView;
  final OnConnectionClose _onConnectionClose;
  final Stream<String> _incoming;
  final SendString _sendString;
  Map<ObjectId, PurityClientModel> _models = new Map<ObjectId, PurityClientModel>();
  bool _modelEventInProgress = false;
  
  PurityClientCore(InitAppView this._initAppView, OnConnectionClose this._onConnectionClose, Stream<String> this._incoming, SendString this._sendString){
    _registerPurityTranTypes();
    _incoming.listen(_receiveString, onError: (_) => _onConnectionClose(), onDone: _onConnectionClose);
  }
  
  void _receiveString(String str){
    var tran = new Transmittable.fromTranString(str, _postprocessTran);
    if(tran is PurityTransmission){
      if(tran is PurityAppSessionInitialisedTransmission){
        _initAppView(tran.model);
      }else if(tran is PurityGarbageCollectionStartTransmission){
        _runGarbageCollectionSequence();
      }
    }else if(tran is PurityEvent){
      _modelEventInProgress = true;
      _models[tran.emitter.purityId].emitEvent(tran).then((_){ _modelEventInProgress = false; });
    }
  }
  
  dynamic _postprocessTran(dynamic v){
    if(v is PurityClientModel){
      if(!_models.containsKey(v.purityId)){
        _models[v.purityId] = v;
        _modelConsumption[v.purityId] = 0;
        listen(v, PurityInvocationEvent, (PurityInvocationEvent pie) => _sendString(pie.toTranString()));
      }
    }
    return v;
  }
  
  void _runGarbageCollectionSequence(){
    if(_modelEventInProgress){
      new Future.delayed(new Duration(), _runGarbageCollectionSequence);
      return;
    }else{
      var modelsCollected = new Set<PurityModelBase>();
      _modelConsumption.forEach((purityId, usageCount){
        if(usageCount == 0){
          var model = _models.remove(purityId);
          ignoreAllEventsFrom(model);
          modelsCollected.add(model);
        }
      });
      modelsCollected.forEach((model){
        _modelConsumption.remove(model.purityId);
      });
      _sendString(new PurityGarbageCollectionReportTransmission()..models = modelsCollected);
    }
  }
}