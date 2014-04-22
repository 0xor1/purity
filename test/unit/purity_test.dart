/**
 * author Daniel Robinson http://github.com/0xor1
 */

library purity.test;

import 'package:unittest/unittest.dart';
import 'package:purity/purity.dart';
import 'dart:async';
import 'dart:math';

part 'purity_core_test.dart';
part 'purity_error_test.dart';

class TestModel extends PurityModel{
  void doStuff(int x){
    emitEvent(
      new TestEvent()
      ..aFakeTestProp = x);
  }
}

class TestView extends PurityModelConsumer{
  TestView(model):super(model){
    listen(model, Omni, (event){
      lastEventCaughtByView = event;
    });
  }
  
  doStuff(int x){
    model.doStuff(x);
  }
}

class TestEvent extends PurityEvent implements ITestEvent{}
abstract class ITestEvent{
  String doingStuffMessage;
}

bool _purityTestTranTypesRegistered = false;
void _registerPurityTestTranTypes(){
  if(_purityTestTranTypesRegistered){return;}
  _purityTestTranTypesRegistered = true;
  registerTranTypes('purity.test', 'pt',(){
    registerTranSubtype('a', TestEvent);
  });
}

PurityTestServer server;
TestModel currentTestModel;
TestView currentTestView;
dynamic modelPassedToView;
TestEvent lastEventCaughtByView;

void runAsyncPurityTest(callback){
  Timer.run(expectAsync((){
    callback();
    expect(true, equals(true));
  }));
}

void _setUp(){
  server = new PurityTestServer(
    ()=> currentTestModel = new TestModel(),
    (model){}
  );
  initPurityTestAppView(
    (model){
      currentTestView = new TestView(model);
    },
    (){}
  );
  server.simulateNewClient();
}

void _tearDown(){
  server = currentTestModel = currentTestView = modelPassedToView = lastEventCaughtByView = null;
}

void main(){  
  _registerPurityTestTranTypes();
  setUp(_setUp);
  tearDown(_tearDown);
  _runCoreTests();
  _runErrorTests();
}