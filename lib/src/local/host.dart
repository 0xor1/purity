/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class Host extends core.Host{

  static int _endPointIdSrc = 0;

  Host(core.InitSource initSrc, core.CloseSource closeSrc, int garbageCollectionFrequency, [bool verbose = true]):
  super(initSrc, closeSrc, garbageCollectionFrequency, verbose);

  void createEndPointPair(){
    if(!core.consumerSettingsInitialised){
      throw new ConsumerSettingsUninitialisedError();
    }
    var biConnectionPair = new EndPointConnectionPair();
    var name = '${_endPointIdSrc++}';
    var proxyEndPoint = new ProxyEndPoint(name, core.initConsumer, core.hanleConnectionClose, biConnectionPair.a);
    var srcEndPoint = createSourceEndPoint(name, biConnectionPair.b);
    emitEvent(
      new ProxyEndPointCreated()
      ..proxyEndPoint = proxyEndPoint);
  }
}

