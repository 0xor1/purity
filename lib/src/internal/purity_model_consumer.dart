/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

abstract class PurityModelConsumer extends Object with EventEmitter, EventDetector{

  PurityModelBase _model;
  PurityModelBase get model => _model;

  PurityModelConsumer(PurityModelBase this._model){
    _modelConsumption[_model.purityId]++;
  }

  /**
   * Dispose of this [View]
   */
  void dispose(){
    ignoreAllEvents();
    _modelConsumption[_model.purityId]--;
    _model = null;
  }

}