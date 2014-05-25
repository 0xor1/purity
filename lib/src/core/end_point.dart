/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point for an [EndPointConnection].
 */
abstract class _EndPoint extends Source{

  final EndPointConnection _connection;

  /// Constructs a new [_EndPoint] instance with the supplied [EndPointConnection].
  _EndPoint(this._connection){
    _registerPurityCoreTranTypes();
    _connection.incoming.listen(_receiveString, onDone: shutdown, onError: (error) => shutdown());
  }

  /// shuts down the [EndPointConnection].
  void shutdown(){
    _connection.close();
    emitEvent(new Shutdown());
  }

  void _receiveString(String str);
}