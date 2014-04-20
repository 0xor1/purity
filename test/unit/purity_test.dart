/**
 * author Daniel Robinson http://github.com/0xor1
 */

library purity.test;

import 'package:unittest/unittest.dart';

part 'purity_core_test.dart';
part 'purity_error_test.dart';

void _setUp(){
  
}

void _tearDown(){
  
}

void main(){
  _runCoreTests();
  _runErrorTests();
}