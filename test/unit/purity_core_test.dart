/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.test;

void _runCoreTests(){
  
  group('Purity Core Tests: ', (){
    
    test('The proxy can make calls to the source and receive events back.', (){
      int x = new Random().nextInt(100);
      Timer.run(() => currentTestConsumer.doStuff(x));
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventCaughtByConsumer != null,
        (){
          expect(lastEventCaughtByConsumer.aFakeTestProp, equals(x));
        });
    });
    
  });
  
}