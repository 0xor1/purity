/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

class PurityTestServer{

  static int testClientId = 0;
  static PurityTestServer _singleton;
  final PurityServerCore purityServerCore;
  static dynamic _createClientView;

  factory PurityTestServer(OpenApp openApp, CloseApp closeApp, [int garbageCollectionFrequency = 60]){
    if(_singleton != null){
      return _singleton;
    }else{
      return new PurityTestServer._internal(new PurityServerCore(openApp, closeApp, garbageCollectionFrequency, true));
    }
  }

  PurityTestServer._internal(PurityServerCore this.purityServerCore){
    _singleton = this;
  }
  


  void simulateNewClient(){
    if(!_hasTestAppViewInitialised){
      throw 'initPurityTestAppView must be called before a new test client can be initialised';
    }
    _StreamPack toServer = new _StreamPack<String>();
    _StreamPack toClient = new _StreamPack<String>();
    new PurityClientCore(_initTestAppView, _onTestConnectionClose, toClient.stream, toServer.controller.add);
    purityServerCore.createPurityAppSession('client_${testClientId++}', toServer.stream, toClient.controller.add);
  }
  
}

