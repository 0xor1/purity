/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runProxyEndPointTests(){

  group('proxy_end_point:', (){

    test('emits Event<Shutdown> on shutdown', (){
      Event<Shutdown> caughtEvent;
      var connectionPair = new local.EndPointConnectionPair();
      var proxyEndPoint = new ProxyEndPoint(
        (_, __){},
        (){},
        connectionPair.a);
      proxyEndPoint.addEventAction(Shutdown, (Event<Shutdown> event) => caughtEvent = event);
      proxyEndPoint.shutdown();
      Timer.run(expectAsync(() => expect(caughtEvent.data is Shutdown, equals(true))));
    });

    test('shuts down when the incoming stream is closed', (){
      Event<Shutdown> caughtEvent;
      var connectionPair = new local.EndPointConnectionPair();
      var proxyEndPoint = new ProxyEndPoint(
        (_, __){},
        (){},
        connectionPair.a);
      proxyEndPoint.addEventAction(Shutdown, (Event<Shutdown> event) => caughtEvent = event);
      connectionPair.b.close();
      expectAsyncWithReadyCheckAndTimeout(
        () => caughtEvent != null,
        () => expect(caughtEvent.data is Shutdown, equals(true)));
    });

    test('closes the outgoing stream on shutdown', (){
      var outgoingStreamClosed = false;
      var connectionPair = new local.EndPointConnectionPair();
      var proxyEndPoint = new ProxyEndPoint(
        (_, __){},
        (){},
        connectionPair.a);
      connectionPair.b.incoming.listen((event){}, onDone: (){ outgoingStreamClosed = true; });
      proxyEndPoint.shutdown();
      expectAsyncWithReadyCheckAndTimeout(
        () => outgoingStreamClosed,
        () => expect(outgoingStreamClosed, equals(true)));
    });

  });

}