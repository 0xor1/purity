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
        srcEndPoint.on(Shutdown, (Event<Shutdown> event) => caughtEvent = event);
        srcEndPoint.shutdown();
      });
    });

    test('sends a _SourceReady when the InitSource method returns a source', (){
      Source initSeed;
      dynamic reTranSeed;
      expectAsyncWithReadyCheckAndTimeout(
        () => reTranSeed != null,
        () => expect(true, equals(true))); //best we can do is just check reTranSeed != null, and that is already the case if we got to this line.
      runZoned((){
        var connectionPair = new local.EndPointConnectionPair();
        connectionPair.b.incoming.listen((str){
          reTranSeed = new Transmittable.fromTranString(str).seed;
        });
        var srcEndPoint = new SourceEndPoint(
          (_) => initSeed = new Source(),
          (_) => new Future((){}),
          2,
          connectionPair.a);
      });
    });

    test('throws a InvalidInitSourceReturnTypeError if initSource doesn\'t return a Source or Fututre<Source>', (){
      var connectionPair = new local.EndPointConnectionPair();
      try{
        var srcEndPoint = new SourceEndPoint(
          (_) => 1, //not a Source or Future<Source>
          (_) => new Future((){}),
          2,
          connectionPair.a);
      }catch(ex){
        expect(ex is InvalidInitSourceReturnTypeError, equals(true));
      }
    });

    test('shuts down when the incoming stream is closed', (){
      Event<Shutdown> caughtEvent;
      var connectionPair = new local.EndPointConnectionPair();
      var srcEndPoint = new SourceEndPoint(
        (_) => new Source(),
        (_){},
        2,
        connectionPair.a);
      srcEndPoint.on(Shutdown, (Event<Shutdown> event) => caughtEvent = event);
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