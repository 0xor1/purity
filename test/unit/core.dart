/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.core.test;

import 'dart:mirrors';
import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:purity/core.dart';

part 'core/source.dart';
part 'core/error.dart';

class _TestSource extends Source{
  bool doStuffCalled = false;
  void doStuff(){
    doStuffCalled = true;
  }
}

class _TestConsumer extends Consumer{
  _TestConsumer(src):super(src);
}

void _tearDown(){
  clearConsumerSettings();
}

void runCoreTests(){

  group('core:', (){
    tearDown(_tearDown);
    _runSourceTests();
    _runErrorTests();
  });

}