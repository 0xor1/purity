/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.error.test;

import 'package:unittest/unittest.dart';
import 'package:purity/core.dart' as core;

void runErrorTests(){

  group('error:', (){

    test('calling initConsumerSettings more than once is an error', (){
      core.initConsumerSettings((_, __){}, (){});
      expect(() => core.initConsumerSettings((_, __){}, (){}), throwsA(new isInstanceOf<core.ConsumerSettingsAlreadyInitialisedError>()));
    });

  });

}