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