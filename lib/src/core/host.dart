/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/**
 * Hosts multiple [SourceEndPoint]s.
 */
abstract class Host extends Source{

  final InitSource _initSrc;
  final CloseSource _closeSrc;
  final int _garbageCollectionFrequency;
  final Set<SourceEndPoint> srcEndPoints = new Set<SourceEndPoint>();
  final bool _verbose;
  
  /**
   * Constructs a new [Host] instance with:
   * 
   * * [_initSrc] as the [InitSource] function for the application.
   * * [_closeSrc] as the [CloseSource] function for the application.
   * * [_garbageCollectionFrequency] as th number of seconds between garbage collection executions. 0 or null to never run garbage collection.
   * * [_verbose] as an optional argument to emit events for each message sent and received from all hosted [SourceEndPoint]s.
   * 
   */
  Host(this._initSrc, this._closeSrc, this._garbageCollectionFrequency, [this._verbose = false]);

  /**
   * Creates a [SourceEndPoint] with the supplied [name] and [connection]
   */
  void createSourceEndPoint(String name, EndPointConnection connection){
    SendString verboseSend = connection._send;
    SendString rootSend = connection._send;
    if(_verbose){
      _emitEndPointMessageEvent(name, true, 'New end-point connected to host');
      connection._incoming.listen(
        (str){
          _emitEndPointMessageEvent(name, true, str);
        },
        onDone: (){ _emitEndPointMessageEvent(name, true, 'End-point connection closed onDone'); },
        onError: (_){ _emitEndPointMessageEvent(name, true, 'End-point connection closed onError'); });
      verboseSend = (String str){
        _emitEndPointMessageEvent(name, false, str);
        rootSend(str);
      };
      connection = new EndPointConnection(connection._incoming, verboseSend, connection._close);
    }
    new SourceEndPoint(_initSrc, _closeSrc, _garbageCollectionFrequency, connection);
  }
  
  /// shuts down all hosted [SourceEndPoint]s.
  void shutdown(){
    srcEndPoints.forEach((srcEndPoint){
      srcEndPoint.shutdown();
    });
    srcEndPoints.clear();
  }
  
  void _emitEndPointMessageEvent(String name, bool isProxyToSource, String str){
    emitEvent(
      new EndPointMessageEvent()
      ..endPointName = name
      ..isProxyToSource = isProxyToSource
      ..message = str);
  }
}