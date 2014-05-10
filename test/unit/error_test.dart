/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.test;

void _runErrorTests(){

  group('Error: ', (){
    
    test('A proxy can make calls to its source and receive events back.', (){
      int x = new Random().nextInt(100);
      executeWhenReadyOrTimeout(() => currentTestConsumer != null, () => currentTestConsumer.doStuff(x));
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventCaughtByConsumer != null,
        (){
          expect(lastEventCaughtByConsumer.aFakeTestProp, equals(x));
        });
    });
    
  });
  
}