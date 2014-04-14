/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

class PurityServerCore extends PurityModel{

  static PurityServerCore _singleton;

  final OpenApp _openApp;
  final CloseApp _closeApp;
  final int garbageCollectionFrequency; //in seconds
  final bool _isTestMode;

  factory PurityServerCore(OpenApp openApp, CloseApp closeApp, [int garbageCollectionFrequency = 60, bool isTestMode = false]){
    if(_singleton != null){
      return _singleton;
    }else{
      return new PurityServerCore._internal(openApp, closeApp, garbageCollectionFrequency, isTestMode);
    }
  }

  PurityServerCore._internal(OpenApp this._openApp, CloseApp this._closeApp, int this.garbageCollectionFrequency, bool this._isTestMode){
    _registerPurityTranTypes();
    _singleton = this;
  }

  void createPurityAppSession(String sessionName, Stream<String> incoming, SendString sendString){
    SendString sessionSendString = sendString;
    if(_isTestMode){
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
      ..clientToServer = true
      ..sessionName = name
      ..tranString = tranStr);
  }
}
