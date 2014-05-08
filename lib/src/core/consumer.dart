/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class Consumer extends Object with EventDetector{

  _Base _src;
  _Base get source => _src;

  Consumer(this._src){
    if(_src is _Proxy){
      (_src as _Proxy)._proxyConsumptionCount[_src._purityId]++;
    }
  }

  /**
   * Dispose of this [Consumer]
   */
  void dispose(){
    ignoreAllEvents();
    if(_src is _Proxy){
      (_src as _Proxy)._proxyConsumptionCount[_src._purityId]--;
    }
    _src = null;
  }

}