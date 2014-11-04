/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runConsumerTests(){

  group('consumer:', (){

    test('can consume a source directly', (){
      var src = new _TestSource();
      var con = new _TestConsumer(src);
      con.doStuff();
      expect(src.doStuffCalled, equals(true));
    });

    test('dispose() removes the reference to the source', (){
      var src = new _TestSource();
      var con = new _TestConsumer(src);
      con.dispose();
      expect(con.source, equals(null));
    });

    test('dispose() removes all the consumers event listeners', (){
      var src = new _TestSource();
      var con = new _TestConsumer(src);
      _TestEvent event;
      con.listen(src, _TestEvent, (Emission<_TestEvent> e){ event = e.data; });
      con.dispose();
      src.emit( new _TestEvent());
      Timer.run(expectAsync(() => expect(event, equals(null))));
    });

  });

}