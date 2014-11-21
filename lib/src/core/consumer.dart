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
class Consumer extends Object with Receiver{
  Source _src;
  /// The [Source] being consumed.
  Source get source => _src;

  /// Constructs a [Consumer] instance with the only [Source] it will consume for its lifetime.
  Consumer(this._src){
    _src._usageCount++;
  }

  /// Disposes the [Consumer] and frees the underlying [Source].
  void dispose(){
    ignoreAll();
    _src._usageCount--;
    _src = null;
  }

}