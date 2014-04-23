/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityTestServer extends PurityModel{

  static int testClientId = 0;
  final PurityServerCore _purityServerCore;
  final List<_StreamPack> _streamPacks = new List<_StreamPack>();

  factory PurityTestServer(OpenApp openApp, CloseApp closeApp, [int garbageCollectionFrequency = 60]){
    var serverCore = new PurityServerCore(openApp, closeApp, garbageCollectionFrequency, true);
    return new PurityTestServer._internal(serverCore);
  }

  PurityTestServer._internal(PurityServerCore this._purityServerCore){
    listen(_purityServerCore, Omni, (event){ emitEvent(event); });    
  }
  
  void simulateNewClient(){
    if(!_hasTestAppViewInitialised){
      throw 'initPurityTestAppView must be called before a new test client can be initialised';
    }
    _StreamPack toServer = new _StreamPack<String>();
    _StreamPack toClient = new _StreamPack<String>();
    _streamPacks.add(toServer);
    _streamPacks.add(toClient);
    String clientId = 'client_${testClientId++}';
    new PurityClientCore(_initTestAppView, _onTestConnectionClose, toClient.stream, toServer.controller.add);
    _purityServerCore.createPurityAppSession(clientId, toServer.stream, toClient.controller.add);
  }
  
  void shutdown(){
    _streamPacks.forEach((pack){
      pack.controller.close();
    });
  }  
}

