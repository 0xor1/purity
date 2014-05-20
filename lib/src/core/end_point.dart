/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point for an [EndPointConnection].
 */
abstract class EndPoint extends Source{

  final EndPointConnection _connection;
  bool _isOpen = false;
  /// Constructs a new [EndPoint] instance with the supplied [EndPointConnection].
  EndPoint(this._connection){
    _registerPurityCoreTranTypes();
  }

  /// shuts down the [EndPointConnection].
  void shutdown(){
    _connection.close();
    emitEvent(new Shutdown());
  }

  /// opens the end-point such that it can start receiving [String] messages
  void open(void receiveString(String str)){
    if(_isOpen){
      throw new EndPointAlreadyOpenError(this);
    }
    _connection.incoming.listen(receiveString, onDone: shutdown, onError: (error) => shutdown());
    _isOpen = true;
  }
}