/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class Consumer extends Object with EventDetector{

  _Base _src;
  dynamic get source => _src;

  Consumer(this._src){
    if(_src is _Proxy){
      _proxyManagers[(_src as _Proxy)._clientId]._proxyConsumptionCount[_src._purityId]++;
    }
  }

  /**
   * Dispose of this [Consumer]
   */
  void dispose(){
    ignoreAllEvents();
    if(_src is _Proxy){
      _proxyManagers[(_src as _Proxy)._clientId]._proxyConsumptionCount[_src._purityId]--;
    }
    _src = null;
  }

}