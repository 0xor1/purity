/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point object, a [Consumer] exists solely to provide representation for a single [Source].
 * 
 * A [Consumer] has a single underlying [Source], it should only be concerned with calling public
 * methods on its [Source] and listening to [Event]s coming from its [Source]. a [Consumer] should
 * not emit its own [Event]s.
 */
class Consumer extends Object with EventDetector{
  _Base _src;
  /// The [Source] being consumed.
  dynamic get source => _src;

  /**
   * Constructs a [Consumer] instance with the only [Source] it will consume for its lifetime.
   */
  Consumer(this._src){
    if(_src is _Proxy){
      (_src as _Proxy)._usageCount++;
    }
  }

  /// Disposes the [Consumer] and frees the underlying [Source].
  void dispose(){
    ignoreAllEvents();
    if(_src is _Proxy){
      (_src as _Proxy)._usageCount--;
    }
    _src = null;
  }

}