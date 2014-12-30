/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */
@PurityLib('purity/purity.core.test', 'pct')
library purity.core.test;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:purity/core.dart';
import 'package:purity/local.dart' as local;
import 'utility.dart';

part 'core/view.dart';
part 'core/error.dart';
part 'core/view_end_point.dart';
part 'core/model_end_point.dart';

_TestModel _ConstTestModel () => new _TestModel();
@PurityModel('_TestModel', _ConstTestModel)
class _TestModel extends Model{
  bool doStuffCalled = false;

  void _doStuff(){
    doStuffCalled = true;
  }

  @PurityMethod('doStuff')
  void doStuff() => method('doStuff', _doStuff);
}

class _TestView extends View<_TestModel>{
  _TestView(model):super(model);
  void doStuff(){
    model.doStuff();
  }
}

_TestEvent _ConstTestEvent () => new _TestEvent();
@PurityEventData('_TestEvent', _ConstTestEvent)
class _TestEvent extends EventData{}

void _tearDown(){
  clearConsumerSettings();
}

void runCoreTests(){

  group('core:', (){
    tearDown(_tearDown);
    _runViewTests();
    _runViewEndPointTests();
    _runModelEndPointTests();
    _runErrorTests();
  });

}