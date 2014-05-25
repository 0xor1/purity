/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runProxySourcePointTests(){

  group('source_end_point:', (){

    test('emits Event<Shutdown> on shutdown', (){
      Event<Shutdown> caughtEvent;
      expectAsyncWithReadyCheckAndTimeout(
        () => caughtEvent != null,
        () => expect(caughtEvent is Event<Shutdown>, equals(true)));
      runZoned((){
        var connectionPair = new local.EndPointConnectionPair();
        var srcEndPoint = new SourceEndPoint(
          (_) => new Future(() => new Source()),
          (_) => new Future((){}),
          2,
          connectionPair.a);
        srcEndPoint.addEventAction(Shutdown, (Event<Shutdown> event) => caughtEvent = event);
        srcEndPoint.shutdown();
      });
    });

    test('shuts down when the incoming stream is closed', (){
      Event<Shutdown> caughtEvent;
      var connectionPair = new local.EndPointConnectionPair();
      var srcEndPoint = new SourceEndPoint(
        (_) => new Future(() => new Source()),
        (_) => new Future((){}),
        2,
        connectionPair.a);
      srcEndPoint.addEventAction(Shutdown, (Event<Shutdown> event) => caughtEvent = event);
      connectionPair.b.close();
      expectAsyncWithReadyCheckAndTimeout(
        () => caughtEvent != null,
        () => expect(caughtEvent.data is Shutdown, equals(true)));
    });

    test('closes the outgoing stream on shutdown', (){
      var outgoingStreamClosed = false;
      var connectionPair = new local.EndPointConnectionPair();
      var srcEndPoint = new SourceEndPoint(
        (_) => new Future(() => new Source()),
        (_) => new Future((){}),
        2,
        connectionPair.a);
      connectionPair.b.incoming.listen((event){}, onDone: (){ outgoingStreamClosed = true; });
      srcEndPoint.shutdown();
      expectAsyncWithReadyCheckAndTimeout(
        () => outgoingStreamClosed,
        () => expect(outgoingStreamClosed, equals(true)));
    });

    test('throws UnsupportedMessageTypeError if an unrecognised message type comes in', (){
      var error;
      expectAsyncWithReadyCheckAndTimeout(
        () => error != null,
        () => expect(error is UnsupportedMessageTypeError, equals(true)));
      runZoned((){
        var connectionPair = new local.EndPointConnectionPair();
        var srcEndPoint = new SourceEndPoint(
          (_) => new Future(() => new Source()),
          (_) => new Future((){}),
          2,
          connectionPair.a);
        connectionPair.b.send(new Transmittable().toTranString());
      }, onError: (e){ error = e; });
    });

  });

}