/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.end_to_end.test;

import 'package:unittest/unittest.dart';
import 'utility.dart';
import 'package:purity/purity.dart';
import 'package:purity/core.dart' as core;
import 'package:purity/local.dart' as local;
import 'dart:async';
import 'dart:mirrors';

void runEndToEndTests(){

  group('end-to-end:', (){

    _registerPurityTestTranTypes();

    setUp(_setUp);
    tearDown(_tearDown);

    test('A consumer can make calls to its source by proxy and receive events back by proxy', (){
      var pi = 3.142;
      executeWhenReadyOrTimeout(() => currentTestConsumer != null, () => currentTestConsumer.doStuff(pi));
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventDataCaughtByConsumer != null,
        (){
          expect(lastEventDataCaughtByConsumer.prop, equals(pi));
        });
    });

    test('A Source may not have #emitEvent invoked on it', (){
      var error;
      expectAsyncWithReadyCheckAndTimeout(
        () => error != null,
        (){
          expect(error is core.RestrictedMethodError, equals(true));
        });

      runZoned(
        (){
          executeWhenReadyOrTimeout(() => currentTestConsumer != null, () => currentTestConsumer.callSourceMethod(#emitEvent));
        },
        onError: (e){
          error = e;
        });
    });

  });

}


class TestSource extends Source{

  void toBeRestricted(){
    restrictedAccessMethodCalled = true;
  }

  void doStuff(x){
    emitEvent(
      new TestEvent()
      ..prop = x);
  }
}

class TestConsumer extends Consumer{
  TestConsumer(src):super(src){
    listen(src, Omni, (Event event){
      lastEventDataCaughtByConsumer = event.data;
    });
  }

  void toBeRestricted(){
    source.toBeRestricted();
  }

  void doStuff(x){
    source.doStuff(x);
  }

  void callSourceMethod(Symbol name){
    reflect(source).invoke(name, []);
  }
}

class TestEvent extends Transmittable implements ITestEvent{}
abstract class ITestEvent{
  dynamic prop;
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
TestEvent lastEventDataCaughtByConsumer;

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
  currentHost = currentTestSrc = currentTestConsumer = srcPassedToConsumer = lastEventDataCaughtByConsumer = null;
  restrictedAccessMethodCalled = false;
}