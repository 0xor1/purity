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

    test('can consume a source by proxy', (){
      var src = new _TestSource();
      var proxy = new Proxy(src.purityId);
      var con = new _TestConsumer(proxy);
      proxy.sendTran = (ProxyInvocation inv){ src.invoke(inv); };
      con.doStuff();
      Timer.run(expectAsync(() => expect(src.doStuffCalled, equals(true))));
    });

  });

}