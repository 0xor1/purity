/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runProxyTests(){

  group('proxy:', (){

    test('can call source methods', (){
      var src = new _TestSource();
      var proxy = new Proxy(src.purityId);
      proxy.sendTran = (ProxyInvocation inv){ src.invoke(inv); };
      proxy.doStuff();
      expect(src.doStuffCalled, equals(true));
    });

    test('does not support getters', (){
      var src = new _TestSource();
      var proxy = new Proxy(src.purityId);
      expect(() => proxy.aGetter, throwsA(new isInstanceOf<UnsupportedProxyInvocationError>()));
    });

    test('does not support setters', (){
      var src = new _TestSource();
      var proxy = new Proxy(src.purityId);
      expect(() => proxy.aSetter = 3.142, throwsA(new isInstanceOf<UnsupportedProxyInvocationError>()));
    });

  });

}