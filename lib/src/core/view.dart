/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point object, a [View] exists solely to provide representation for a single [Model].
 *
 * A [View] has a single underlying [Model], it should only be concerned with calling public
 * methods on its [Model] and listening to [Event]s coming from its [Model]. a [View] should
 * not emit its own [Event]s.
 */
class View<T extends Model> extends Object with Receiver{
  T _model;
  /// The [Model] being consumed.
  T get model => _model;

  /// Constructs a [View] instance with the only [Model] it will consume for its lifetime.
  View(this._model){
    _model._usageCount++;
  }

  /// Disposes the [View] and frees the underlying [Model].
  void dispose(){
    ignoreAll();
    _model._usageCount--;
    _model = null;
  }

}