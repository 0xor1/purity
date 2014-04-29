/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityServerCore extends PurityModel{

  final OpenApp _openApp;
  final CloseApp _closeApp;
  final int garbageCollectionFrequency; //in seconds
  final bool _isTestMode;
  final List<PurityAppSession> _appSessions = new List<PurityAppSession>();

  PurityServerCore(OpenApp this._openApp, CloseApp this._closeApp, [int this.garbageCollectionFrequency = 60, bool this._isTestMode = false]){
    _registerPurityTranTypes();
  }

  void createPurityAppSession(String sessionName, Stream<String> incoming, SendString sendString, Action closeStream){
    SendString sessionSendString = sendString;
    if(_isTestMode){
      _emitPurityServerMessageEvent(sessionName, true, 'New client connected to server');
      incoming.listen(
        (str){ _emitPurityServerMessageEvent(sessionName, true, str); },
        onDone: (){ _emitPurityServerMessageEvent(sessionName, true, 'Client connection closed onDone'); },
        onError: (_){ _emitPurityServerMessageEvent(sessionName, true, 'Client connection closed onError'); });
      sessionSendString = (String str){
        _emitPurityServerMessageEvent(sessionName, false, str);
        sendString(str);
      };
    }
    var session = new PurityAppSession(sessionName, _openApp(), _closeApp, incoming, sessionSendString, closeStream, garbageCollectionFrequency);
    listen(session, PurityAppSessionShutdownEvent, (event){ _appSessions.remove(event.emitter); emitEvent(event); });
    _appSessions.add(session);
  }
  
  void shutdown(){
    _appSessions.forEach((session){
      session.shutdown();
    });
  }
  
  void _emitPurityServerMessageEvent(String name, bool isClientToServer, String tranStr){
    emitEvent(
      new PurityServerMessageEvent()
      ..sessionName = name
      ..clientToServer = isClientToServer
      ..tranString = tranStr);
  }
}
