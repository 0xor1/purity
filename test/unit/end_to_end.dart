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

    test('EventEmiiter and EventDetector contain the expected methods', (){
      //this test is to check we are still blocking the expected methods, it's not full proof but it's better than nothing.
      var expectedMethods = [
        #emitEvent,
        #addEventAction,
        #removeEventAction,
        #listen,
        #ignoreSpecificEventBinding,
        #ignoreAllEventsOfType,
        #ignoreAllEventsFrom,
        #ignoreAllEvents
      ];

      var eventEmitterMembers = reflectClass(EventEmitter).instanceMembers.keys;
      var eventDetectorMembers = reflectClass(EventDetector).instanceMembers.keys;

      expectedMethods.forEach((symbol){
        expect(eventEmitterMembers.contains(symbol) || eventDetectorMembers.contains(symbol), equals(true));
      });
    });

    test('A Source may not have #emitEvent invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#emitEvent);
        });
    });

    test('A Source may not have #addEventAction invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#addEventAction);
        });
    });

    test('A Source may not have #removeEventAction invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#removeEventAction);
        });
    });

    test('A Source may not have #listen invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#listen);
        });
    });

    test('A Source may not have #ignoreSpecificEventBinding invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#ignoreSpecificEventBinding);
        });
    });

    test('A Source may not have #ignoreAllEventsOfType invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#ignoreAllEventsOfType);
        });
    });

    test('A Source may not have #ignoreAllEventsFrom invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#ignoreAllEventsFrom);
        });
    });

    test('A Source may not have #ignoreAllEvents invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        (){
        return lastErrorCaughtDuringTest != null;
        },(){
          expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#ignoreAllEvents, [null]);
        });
    });

    test('A Source may not have a private method invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is ArgumentError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          currentTestConsumer.callSourceMethod(#_aPrivateMethod);
        });
    });

    test('calling a getter on a proxy results in an UnsupportedProxyInvocationError', (){
      var error;
      expectAsyncWithReadyCheckAndTimeout(
        () => error != null,
        (){
          expect(error is core.UnsupportedProxyInvocationError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          try{
            currentTestConsumer.callGetter();
          }catch(e){
            error = e;
          }
        });
    });

    test('calling a setter on a proxy results in an UnsupportedProxyInvocationError', (){
      var error;
      expectAsyncWithReadyCheckAndTimeout(
        () => error != null,
        (){
          expect(error is core.UnsupportedProxyInvocationError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        (){
          try{
            currentTestConsumer.callGetter();
          }catch(e){
            error = e;
          }
        });
    });

  });

}


class TestSource extends Source{

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

  void doStuff(x){
    source.doStuff(x);
  }

  void callSourceMethod(Symbol name, [List<dynamic> posArgs]){
    posArgs = posArgs == null? []: posArgs;
    reflect(source).invoke(name, posArgs);
  }

  void callGetter(){
    return source.aGetter;
  }

  void callSetter(){
    source.aSetter = 1;
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
dynamic lastErrorCaughtDuringTest;
TestEvent lastEventDataCaughtByConsumer;

void _setUp(){

  runZoned((){
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
    },
    onError:(error){
      lastErrorCaughtDuringTest = error;
    });
}

void _tearDown(){
  currentHost.shutdown();
  local.clearConsumerSettings();
  currentHost = currentTestSrc = currentTestConsumer =
  srcPassedToConsumer = lastEventDataCaughtByConsumer =
  lastErrorCaughtDuringTest = null;
  restrictedAccessMethodCalled = false;
}