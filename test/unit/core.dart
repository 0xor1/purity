/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.core.test;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:purity/core.dart';
import 'package:purity/local.dart' as local;
import 'utility.dart';

part 'core/consumer.dart';
part 'core/error.dart';
part 'core/proxy_end_point.dart';
part 'core/source_end_point.dart';

class _TestSource extends Source{
  bool doStuffCalled = false;
  void doStuff(){
    doStuffCalled = true;
  }
}

class _TestConsumer extends Consumer{
  _TestConsumer(src):super(src);
  void doStuff(){
    source.doStuff();
  }
}

class _TestEvent extends Transmittable{}

void _tearDown(){
  clearConsumerSettings();
}

void runCoreTests(){

  group('core:', (){
    tearDown(_tearDown);
    _runConsumerTests();
    _runProxyEndPointTests();
    _runProxySourcePointTests();
    _runErrorTests();
  });

}