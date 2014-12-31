/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Hosts multiple [ModelEndPoint]s.
 */
abstract class ServerCore extends Model{

  final SeedApplication _seedApplication;
  final CloseSource _closeSrc;
  final int _garbageCollectionFrequency;
  final Set<ModelEndPoint> srcEndPoints = new Set<ModelEndPoint>();
  final bool _verbose;

  /**
   * Constructs a new [ServerCore] instance with:
   *
   * * [_seedApplication] as the [SeedApplication] function for the application.
   * * [_closeSrc] as the [CloseSource] function for the application.
   * * [_garbageCollectionFrequency] as th number of seconds between garbage collection executions. 0 or null to never run garbage collection.
   * * [_verbose] as an optional argument to emit events for each message sent and received from all hosted [ModelEndPoint]s.
   *
   */
  ServerCore(this._seedApplication, this._closeSrc, this._garbageCollectionFrequency, [this._verbose = false]);

  /**
   * Creates a [ModelEndPoint] with the supplied [name] and [connection]
   */
  ModelEndPoint createSourceEndPoint(String name, EndPointConnection connection){
    SendString verboseSend = connection.send;
    SendString rootSend = connection.send;
    if(_verbose){
      _emitEndPointMessageEvent(name, true, 'New end-point connected to host');
      connection.incoming.listen(
        (str){
          _emitEndPointMessageEvent(name, true, str);
        },
        onDone: (){ _emitEndPointMessageEvent(name, true, 'End-point connection closed onDone'); },
        onError: (_){ _emitEndPointMessageEvent(name, true, 'End-point connection closed onError'); });
      verboseSend = (String str){
        _emitEndPointMessageEvent(name, false, str);
        rootSend(str);
      };
      connection = new EndPointConnection(connection.incoming, verboseSend, connection.close);
    }
    var srcEndPoint = new ModelEndPoint(_seedApplication, _closeSrc, _garbageCollectionFrequency, connection);
    listen(srcEndPoint, Shutdown, (event){
      _emitEndPointMessageEvent(name, false, 'Source end-point shutdown');
      srcEndPoints.remove(event.emitter);
      Timer.run((){ ignoreEmitter(event.emitter); });
    });
    srcEndPoints.add(srcEndPoint);
    return srcEndPoint;
  }

  /// shuts down all hosted [ModelEndPoint]s.
  void shutdown(){
    srcEndPoints.forEach((srcEndPoint){
      srcEndPoint.shutdown();
    });
  }

  void _emitEndPointMessageEvent(String name, bool isProxyToSource, String str){
    emit(
      new EndPointMessage()
      ..endPointName = name
      ..isClientToServer = isProxyToSource
      ..message = str);
  }
}