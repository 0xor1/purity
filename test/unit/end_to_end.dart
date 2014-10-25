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
import 'dart:math';

void runEndToEndTests(){

  group('end-to-end:', (){

    _registerPurityTestTranTypes();

    setUp(_setUp);
    tearDown(_tearDown);

    test('a consumer can make calls to its source by proxy and receive events back by proxy', (){
      var pi = 3.142;
      executeWhenReadyOrTimeout(() => currentTestConsumer != null, () => currentTestConsumer.doStuff(pi));
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventDataCaughtByConsumer != null,
        () => expect(lastEventDataCaughtByConsumer.prop, equals(pi)));
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

    test('a Source may not have #emitEvent invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#emitEvent));
    });

    test('a Source may not have #addEventAction invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#addEventAction));
    });

    test('a Source may not have #removeEventAction invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#removeEventAction));
    });

    test('a Source may not have #listen invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#listen));
    });

    test('a Source may not have #ignoreSpecificEventBinding invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreSpecificEventBinding));
    });

    test('a Source may not have #ignoreAllEventsOfType invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreAllEventsOfType));
    });

    test('a Source may not have #ignoreAllEventsFrom invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreAllEventsFrom));
    });

    test('a Source may not have #ignoreAllEvents invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreAllEvents, [null]));
    });

    test('a Source may not have a private method invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is ArgumentError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#_aPrivateMethod));
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

    test('unused sources are properly garbage collected', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => memoryLeakTestComplete,
        (){
          expect(lastErrorCaughtDuringTest == null, equals(true));
        },
        20);
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.runMemoryLeakSequence());
    });

    test('$massivesToCreateToEnsureCrash Massive objects is enough to cause OutOfMemoryError', (){
      List<double> _memoryUser = new List<double>();
      var success = false;
      var count = massivesToCreateToEnsureCrash;
      try{
        var rng = new Random();
        while(count-- > 0){
          for(var i = 0; i < massiveSize; i++){
            _memoryUser.add(rng.nextDouble());
          }
        }
      }on OutOfMemoryError catch(error){
        _memoryUser.clear();
        success = true;
      }finally{
        expect(success, equals(true));
      }
    });

  });

}


class TestSource extends Source{
  final List<Massive> _massives = new List<Massive>();

  void doStuff(x){
    emitEvent(
      new TestEvent()
      ..prop = x);
  }

  void createAMassiveObject() {
    var massive = new Massive();
    _massives.add(massive);
    emitEvent(
      new MassiveObjectCreated()
      ..massive = massive);
  }

  void deleteAMassiveObject() {
    if(_massives.isNotEmpty){
      emitEvent(
        new MassiveObjectDeleted()
        ..massive = _massives.removeLast());
    }
  }
}

class Massive extends Source{
  final List<double> _memoryUser = new List<double>();
  Massive(){
    var rng = new Random();
    try{
      for(var i = 0; i < massiveSize; i++){
        _memoryUser.add(rng.nextDouble());
      }
    }on OutOfMemoryError catch(error){
      _memoryUser.clear();
      throw error;
    }
  }
}

class TestConsumer extends Consumer{

  final List<MassiveConsumer> _massives = new List<MassiveConsumer>();
  int massivesToCreateToEnsureNoMemoryLeaks = massivesToCreateToEnsureCrash;

  TestConsumer(src):super(src){
    _addEventHandlers();
  }

  _addEventHandlers(){
    listen(source, Omni, (Event event){
      lastEventDataCaughtByConsumer = event.data;
    });
    listen(source, MassiveObjectCreated, (Event<MassiveObjectCreated> event){
      _massives.add(new MassiveConsumer(event.data.massive));
      Timer.run((){
        source.deleteAMassiveObject();
      });
    });
    listen(source, MassiveObjectDeleted, (Event<MassiveObjectDeleted> event){
      var massive = _massives.singleWhere((massive) => event.data.massive == massive.source);
      _massives.remove(massive);
      massive.dispose();
      if(massivesToCreateToEnsureNoMemoryLeaks-- > 0){
        source.createAMassiveObject();
      }else{
        memoryLeakTestComplete = true;
      }
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

  void runMemoryLeakSequence(){
    source.createAMassiveObject();
  }
}

class MassiveConsumer extends Consumer{
  MassiveConsumer(src):super(src);
}

class TestEvent extends Transmittable implements ITestEvent{}
abstract class ITestEvent{
  dynamic prop;
}


class MassiveObjectDeleted extends Transmittable implements IMassiveObjectCreatedOrDeleted{}
class MassiveObjectCreated extends Transmittable implements IMassiveObjectCreatedOrDeleted{}
abstract class IMassiveObjectCreatedOrDeleted{
  dynamic massive;
}

final Registrar _registerPurityTestTranTypes = generateRegistrar(
    'purity.test', 'pt', [
    new TranRegistration.subtype(TestEvent, () => new TestEvent()),
    new TranRegistration.subtype(MassiveObjectDeleted, () => new MassiveObjectDeleted()),
    new TranRegistration.subtype(MassiveObjectCreated, () => new MassiveObjectCreated()),
  ]);

const int massivesToCreateToEnsureCrash = 50;
const int massiveSize = 1000000;
bool restrictedAccessMethodCalled = false;
bool memoryLeakTestComplete = false;
local.Host currentHost;
local.ProxyEndPoint currentproxyEndPoint;
TestSource currentTestSrc;
TestConsumer currentTestConsumer;
dynamic srcPassedToConsumer;
dynamic lastErrorCaughtDuringTest;
dynamic lastEventDataCaughtByConsumer;

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