/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Hosts multiple [SourceEndPoint]s.
 */
abstract class Host extends Source{

  final SeedApplication _seedApplication;
  final CloseSource _closeSrc;
  final int _garbageCollectionFrequency;
  final Set<SourceEndPoint> srcEndPoints = new Set<SourceEndPoint>();
  final bool _verbose;

  /**
   * Constructs a new [Host] instance with:
   *
   * * [_seedApplication] as the [SeedApplication] function for the application.
   * * [_closeSrc] as the [CloseSource] function for the application.
   * * [_garbageCollectionFrequency] as th number of seconds between garbage collection executions. 0 or null to never run garbage collection.
   * * [_verbose] as an optional argument to emit events for each message sent and received from all hosted [SourceEndPoint]s.
   *
   */
  Host(this._seedApplication, this._closeSrc, this._garbageCollectionFrequency, [this._verbose = false]);

  /**
   * Creates a [SourceEndPoint] with the supplied [name] and [connection]
   */
  SourceEndPoint createSourceEndPoint(String name, EndPointConnection connection){
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
    var srcEndPoint = new SourceEndPoint(_seedApplication, _closeSrc, _garbageCollectionFrequency, connection);
    listen(srcEndPoint, Shutdown, (event){
      _emitEndPointMessageEvent(name, false, 'Source end-point shutdown');
      srcEndPoints.remove(event.emitter);
      Timer.run((){ ignoreFrom(event.emitter); });
    });
    srcEndPoints.add(srcEndPoint);
    return srcEndPoint;
  }

  /// shuts down all hosted [SourceEndPoint]s.
  void shutdown(){
    srcEndPoints.forEach((srcEndPoint){
      srcEndPoint.shutdown();
    });
  }

  void _emitEndPointMessageEvent(String name, bool isProxyToSource, String str){
    emit(
      new EndPointMessage()
      ..endPointName = name
      ..isProxyToSource = isProxyToSource
      ..message = str);
  }
}