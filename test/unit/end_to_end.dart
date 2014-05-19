/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.end_to_end.test;

import 'package:unittest/unittest.dart';
import 'utility.dart';
import 'package:purity/purity.dart';
import 'package:purity/local.dart' as local;
import 'dart:async';
import 'dart:math';

void runEndToEndTests(){

  group('end-to-end:', (){

    _registerPurityTestTranTypes();

    setUp(_setUp);
    tearDown(_tearDown);

    test('A proxy can make calls to its source and receive events back.', (){
      int x = new Random().nextInt(100);
      executeWhenReadyOrTimeout(() => currentTestConsumer != null, () => currentTestConsumer.doStuff(x));
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventCaughtByConsumer != null,
        (){
          expect(lastEventCaughtByConsumer.aFakeTestProp, equals(x));
        });
    });
  });

}


class TestSource extends Source{

  void toBeRestricted(){
    restrictedAccessMethodCalled = true;
  }

  void doStuff(int x){
    emitEvent(
      new TestEvent()
      ..aFakeTestProp = x);
  }
}

class TestConsumer extends Consumer{
  TestConsumer(src):super(src){
    listen(src, Omni, (Event event){

      lastEventCaughtByConsumer = event.data;
    });
  }

  void toBeRestricted(){
    source.toBeRestricted();
  }

  doStuff(int x){
    source.doStuff(x);
  }
}

class TestEvent extends Transmittable implements ITestEvent{}
abstract class ITestEvent{
  String doingStuffMessage;
}

bool _purityTestTranTypesRegistered = false;
void _registerPurityTestTranTypes(){
  if(_purityTestTranTypesRegistered){ return; }
  _purityTestTranTypesRegistered = true;
  registerTranTypes('purity.test', 'pt',(){
    registerTranSubtype('a', TestEvent);
  });
}

bool restrictedAccessMethodCalled = false;
local.Host currentHost;
local.ProxyEndPoint currentproxyEndPoint;
TestSource currentTestSrc;
TestConsumer currentTestConsumer;
dynamic srcPassedToConsumer;
TestEvent lastEventCaughtByConsumer;

void _setUp(){

  currentHost = new local.Host(
    (_) => new Future.delayed(new Duration(), () => currentTestSrc = new TestSource()),
    (src) => new Future.delayed(new Duration(), (){}),
    2);

  local.initConsumerSettings(
    (src, proxyEndPoint){
      currentproxyEndPoint = proxyEndPoint;
      currentTestConsumer = new TestConsumer(src);
    },
    (){}
  );

  currentHost.createEndPointPair();
}

void _tearDown(){
  currentHost.shutdown();
  local.clearConsumerSettings();
  currentHost = currentTestSrc = currentTestConsumer = srcPassedToConsumer = lastEventCaughtByConsumer = null;
}