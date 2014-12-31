/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class Server extends core.ServerCore {

  static int _endPointIdSrc = 0;

  Server(core.SeedApplication seedApplication, [core.CloseSource closeSrc = null, int gcFreq = 0, bool verbose = true]) : super(seedApplication, closeSrc, gcFreq, verbose);

  void createEndPointPair() {
    if (!core.consumerSettingsInitialised) {
      throw new ConsumerSettingsUninitialisedError();
    }
    var biConnectionPair = new EndPointConnectionPair();
    var name = '${_endPointIdSrc++}';
    var proxyEndPoint = new ViewEndPoint(name, core.initConsumer, core.hanleConnectionClose, biConnectionPair.a);
    var srcEndPoint = createSourceEndPoint(name, biConnectionPair.b);
    emit(new ProxyEndPointCreated()..proxyEndPoint = proxyEndPoint);
  }
}
