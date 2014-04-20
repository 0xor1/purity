/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

abstract class PurityModelConsumer extends Object with EventEmitter, EventDetector{

  PurityModelBase _model;
  PurityModelBase get model => _model;

  PurityModelConsumer(PurityModelBase this._model){
    if(_model is PurityClientModel){
      _clientCores[(_model as PurityClientModel)._clientId]._modelConsumption[_model._purityId]++;
    }
  }

  /**
   * Dispose of this [View]
   */
  void dispose(){
    ignoreAllEvents();
    if(_model is PurityClientModel){
      _clientCores[(_model as PurityClientModel)._clientId]._modelConsumption[_model._purityId]++;
    }
    _model = null;
  }

}