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
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventDataCaughtByConsumer != null,
        () => expect(lastEventDataCaughtByConsumer.prop, equals(pi)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.doStuff(pi));
    });

    test('Emiiter and Receiver contain the expected methods', (){
      //this test is to check we are still blocking the expected methods, it's not full proof but it's better than nothing.
      var expectedMethods = [
        #emit,
        #on,
        #once,
        #off,
        #listen,
        #listenOnce,
        #ignoreTypeFromEmitter,
        #ignoreType,
        #ignoreEmitter,
        #ignoreAll
      ];

      var eventEmitterMembers = reflectClass(Emitter).instanceMembers.keys;
      var eventDetectorMembers = reflectClass(Receiver).instanceMembers.keys;

      expectedMethods.forEach((symbol){
        expect(eventEmitterMembers.contains(symbol) || eventDetectorMembers.contains(symbol), equals(true));
      });
    });

    test('a Source may not have #emit invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#emit));
    });

    test('a Source may not have #on invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#on));
    });

    test('a Source may not have #once invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#once));
    });

    test('a Source may not have #off invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#off));
    });

    test('a Source may not have #listen invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#listen));
    });

    test('a Source may not have #listenOnce invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#listenOnce));
    });

    test('a Source may not have #ignoreTypeFromEmitter invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreTypeFromEmitter));
    });

    test('a Source may not have #ignoreType invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreType));
    });

    test('a Source may not have #ignoreEmitter invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreEmitter));
    });

    test('a Source may not have #ignoreAll invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        () => expect(lastErrorCaughtDuringTest is core.RestrictedMethodError, equals(true)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#ignoreAll, [null]));
    });

    test('a Source may not have #_invoke invoked on it', (){
      expectAsyncWithReadyCheckAndTimeout(
        () => lastErrorCaughtDuringTest != null,
        (){
          expect(lastErrorCaughtDuringTest is ArgumentError, equals(true));
        });
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.callSourceMethod(#_invoke));
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
    emit(
      new TestEvent()
      ..prop = x);
  }

  void createAMassiveObject() {
    var massive = new Massive();
    _massives.add(massive);
    emit(
      new MassiveObjectCreated()
      ..massive = massive);
  }

  void _aPrivateMethod(){
    print('private method called');
  }

  void deleteAMassiveObject() {
    if(_massives.isNotEmpty){
      emit(
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
    listen(source, All, (Event e){
      lastEventDataCaughtByConsumer = e.data;
    });
    listen(source, MassiveObjectCreated, (Event<MassiveObjectCreated> e){
      _massives.add(new MassiveConsumer(e.data.massive));
      Timer.run((){
        source.deleteAMassiveObject();
      });
    });
    listen(source, MassiveObjectDeleted, (Event<MassiveObjectDeleted> e){
      var massive = _massives.singleWhere((massive) => e.data.massive == massive.source);
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

class TestEvent extends Transmittable{
  dynamic get prop => get('prop');
  void set prop (o) => set('prop', o);
}


class MassiveObjectDeleted extends MassiveObjectCreatedOrDeleted{}
class MassiveObjectCreated extends MassiveObjectCreatedOrDeleted{}
class MassiveObjectCreatedOrDeleted extends Transmittable{
  dynamic get massive => get('massive');
  void set massive (o) => set('massive', o);
}

final Registrar _registerPurityTestTranTypes = generateRegistrar(
    'purity.test', 'pt', [
    new TranRegistration.subtype(TestEvent, () => new TestEvent()),
    new TranRegistration.subtype(MassiveObjectDeleted, () => new MassiveObjectDeleted()),
    new TranRegistration.subtype(MassiveObjectCreated, () => new MassiveObjectCreated()),
  ]);

const int massivesToCreateToEnsureCrash = 100;
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
      1);

    local.initConsumerSettings(
      (src, proxyEndPoint){
        currentproxyEndPoint = proxyEndPoint;
        currentTestConsumer = new TestConsumer(src);
      },
      (){});

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
