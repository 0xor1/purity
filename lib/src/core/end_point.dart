/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * An end-point using an [EndPointConnection].
 */
abstract class EndPoint extends Source{
  
  final EndPointConnection _connection;
  
  /// Constructs a new [EndPoint] instance with the supplied [EndPointConnection].
  EndPoint(this._connection);
  
  /// shuts down the [EndPointConnection].
  void shutdown(){
    _connection._close();
  }
}