/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class Host extends core.Host{

  static int _endPointIdSrc = 0;

  Host(core.InitSource initSrc, core.CloseSource closeSrc, int garbageCollectionFrequency, [bool verbose = true])
      :super(initSrc, closeSrc, garbageCollectionFrequency, verbose);
  
  void createEndPointPair(){
    if(!core.consumerSettingsInitialised){
      throw 'initConsumptionSettings must be called before a new test client can be initialised';
    }
    var biConnectionPair = new EndPointConnectionPair();
    var name = 'end-point_${_endPointIdSrc++}';
    var proxyEndPoint = new ProxyEndPoint(name, core.initConsumer, core.hanleConnectionClose, biConnectionPair.a);
    createSourceEndPoint(name, biConnectionPair.b);
    emitEvent(
      new ProxyEndPointCreatedEvent()
      ..proxyEndPoint = proxyEndPoint);
  }
}

