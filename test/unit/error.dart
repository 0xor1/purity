/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.test;

void _runErrorTests(){

  group('Error:', (){

    test('calling initConsumerSettings more than once is an error', (){
      expect(() => core.initConsumerSettings((_, __){}, (){}), throwsA(new isInstanceOf<core.ConsumerSettingsAlreadyInitialisedError>()));
    });

  });

}