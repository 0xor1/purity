/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runViewTests(){

  group('view:', (){

    test('can consume a model directly', (){
      var src = new _TestModel();
      var con = new _TestView(src);
      con.doStuff();
      expect(src.doStuffCalled, equals(true));
    });

    test('dispose() removes the reference to the model', (){
      var src = new _TestModel();
      var con = new _TestView(src);
      con.dispose();
      expect(con.model, equals(null));
    });

    test('dispose() removes all the views event listeners', (){
      var src = new _TestModel();
      var con = new _TestView(src);
      _TestEvent event;
      con.listen(src, _TestEvent, (Event<_TestEvent> e){ event = e.data; });
      con.dispose();
      src.emit( new _TestEvent());
      Timer.run(expectAsync(() => expect(event, equals(null))));
    });

  });

}