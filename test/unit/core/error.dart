/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core.test;

void _runErrorTests(){

  group('error:', (){

    test('calling initConsumerSettings more than once is an error', (){
      initConsumerSettings((_, __){}, (){});
      expect(() => initConsumerSettings((_, __){}, (){}), throwsA(new isInstanceOf<ConsumerSettingsAlreadyInitialisedError>()));
    });

  });

}