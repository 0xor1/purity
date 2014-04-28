/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.test;

void _runCoreTests(){
  
  group('Purity Core Tests: ', (){
    
    test('The clients remote proxy model can make calls to the server model and receive events back.', (){
      int x = new Random().nextInt(100);
      Timer.run(() => currentTestView.doStuff(x));
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventCaughtByView != null,
        (){
          expect(lastEventCaughtByView.aFakeTestProp, equals(x));
        });
    });
    
  });
  
}