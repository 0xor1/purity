/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

abstract class Server extends Source{

  final InitSource _initSrc;
  final CloseSource _closeSrc;
  final int _garbageCollectionFrequency; //in seconds
  final bool _verbose;  

  Server(this._initSrc, this._closeSrc, this._garbageCollectionFrequency, [this._verbose = false]);

  void createSourceManager(String name, BiConnection connection){
    SendString verboseSend = connection._send;
    SendString rootSend = connection._send;
    if(_verbose){
      _emitServerMessageEvent(name, true, 'New client connected to server');
      connection._incoming.listen((str){
        _emitServerMessageEvent(name, true, str);
      },
      onDone: (){ _emitServerMessageEvent(name, true, 'Client connection closed onDone'); },
      onError: (_){ _emitServerMessageEvent(name, true, 'Client connection closed onError'); });
      verboseSend = (String str){
        _emitServerMessageEvent(name, false, str);
        rootSend(str);
      };
      connection = new BiConnection(connection._incoming, verboseSend, connection._close);
    }
    new SourceManager(_initSrc, _closeSrc, connection, _garbageCollectionFrequency);
  }
  
  void _emitServerMessageEvent(String name, bool isClientToServer, String tranStr){
    emitEvent(
      new ServerMessageEvent()
      ..sessionName = name
      ..isClientToServer = isClientToServer
      ..tranString = tranStr);
  }
}