/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityServerCore extends PurityModel{

  final OpenApp _openApp;
  final CloseApp _closeApp;
  final int garbageCollectionFrequency; //in seconds
  final bool _isTestMode;

  PurityServerCore(OpenApp this._openApp, CloseApp this._closeApp, [int this.garbageCollectionFrequency = 60, bool this._isTestMode = false]){
    _registerPurityTranTypes();
  }

  void createPurityAppSession(String sessionName, Stream<String> incoming, SendString sendString){
    SendString sessionSendString = sendString;
    if(_isTestMode){
      _emitPurityServerMessageEvent(sessionName, true, 'New client connected to server');
      incoming.listen((str){
        _emitPurityServerMessageEvent(sessionName, true, str);
      });
      sessionSendString = (String str){
        _emitPurityServerMessageEvent(sessionName, false, str);
        sendString(str);
      };
    }
    new PurityAppSession(sessionName, _openApp(), _closeApp, incoming, sessionSendString, garbageCollectionFrequency);
  }
  
  void _emitPurityServerMessageEvent(String name, bool isClientToServer, String tranStr){
    emitEvent(
      new PurityServerMessageEvent()
      ..sessionName = name
      ..clientToServer = isClientToServer
      ..tranString = tranStr);
  }
}
