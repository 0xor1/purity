/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.test;

void _runCoreTests(){
  
  group('Purity Core Tests: ', (){
    
  test('The clients remote proxy model can make calls to the server model and receive events back.', (){
    runAsyncPurityTest((){
        int x = new Random().nextInt(100);
        currentTestView.doStuff(x);
        var inner; 
        inner = (){
          Timer.run(expectAsync((){ //this seems like a crazy way to test through multiple asynchronous events.
            if(lastEventCaughtByView == null){
              inner();
            }else{
              expect(lastEventCaughtByView.aFakeTestProp, equals(x));
            }
          }));
        };
        inner();
      });
    });
  });
  
}