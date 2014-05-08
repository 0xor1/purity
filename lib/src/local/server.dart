/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class PurityTestServer extends Source{

  int _testClientId = 0;
  final PurityServerCore _purityServerCore;

  factory PurityTestServer(OpenApp openApp, CloseApp closeApp, [int garbageCollectionFrequency = 60]){
    var serverCore = new PurityServerCore(openApp, closeApp, garbageCollectionFrequency, true);
    return new PurityTestServer._internal(serverCore);
  }

  PurityTestServer._internal(PurityServerCore this._purityServerCore){
    listen(_purityServerCore, Omni, (event){ emitEvent(event); });    
  }
  
  void shutdown() => _purityServerCore.shutdown();
  
  void simulateNewClient(){
    if(!hasTestAppViewInitialised){
      throw 'initPurityTestAppView must be called before a new test client can be initialised';
    }
    _StreamPack toServer = new _StreamPack<String>();
    _StreamPack toClient = new _StreamPack<String>();
    var name = 'client_${_testClientId++}';
    new PurityClientCore(name, initTestAppView, onTestConnectionClose, toClient.stream, toServer.controller.add, toServer.controller.close);
    _purityServerCore.createPurityAppSession(name, toServer.stream, toClient.controller.add, toClient.controller.close);
  }
}

