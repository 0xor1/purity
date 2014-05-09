/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class Server extends core.Server{

  int _localClientId = 0;

  Server(core.InitSource initSrc, core.CloseSource closeSrc, int garbageCollectionFrequency, [bool verbose = true])
      :super(initSrc, closeSrc, garbageCollectionFrequency, verbose);
  
  void newClient(){
    if(!core.consumptionSettingsInitialised){
      throw 'initConsumptionSettings must be called before a new test client can be initialised';
    }
    var biConnectionPair = new BiConnectionPair();
    var name = 'client_${_localClientId++}';
    var proxyManager = new core.ProxyManager(core.initConsumption, core.onConnectionClose, biConnectionPair.a);
    createSourceManager(name, biConnectionPair.b);
    emitEvent(
      new ClientCreatedEvent()
      ..name = name
      ..proxyManager = proxyManager);
  }
}

