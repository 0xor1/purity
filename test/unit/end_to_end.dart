/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */
@PurityLib('purity/purity.end_to_end.test', 'pet')
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

    setUp(_setUp);
    tearDown(_tearDown);

    test('a view can make calls to its model by proxy and receive events back by proxy', (){
      var pi = 3.142;
      expectAsyncWithReadyCheckAndTimeout(
        () => lastEventDataCaughtByConsumer != null,
        () => expect(lastEventDataCaughtByConsumer.prop, equals(pi)));
      executeWhenReadyOrTimeout(
        () => currentTestConsumer != null,
        () => currentTestConsumer.doStuff(pi));
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

TestModel _ConstTestModel () => new TestModel();
@PurityModel('TestSource', _ConstTestModel)
class TestModel extends Model{
  final List<Massive> _massives = new List<Massive>();

  @PurityMethod('doStuff')
  void doStuff(x) => method('doStuff', _doStuff, [x]);

  void _doStuff(x){
    emit(
      new TestEvent()
      ..prop = x);
  }

  @PurityMethod('createAMassiveObject')
  void createAMassiveObject() => method('createAMassiveObject', _createAMassiveObject);

  void _createAMassiveObject() {
    var massive = new Massive();
    _massives.add(massive);
    emit(
      new MassiveObjectCreated()
      ..massive = massive);
  }

  void _aPrivateMethod(){
    print('private method called');
  }

  @PurityMethod('deleteAMassiveObject')
  void deleteAMassiveObject() => method('deleteAMassiveObject', _deleteAMassiveObject);

  void _deleteAMassiveObject() {
    if(_massives.isNotEmpty){
      emit(
        new MassiveObjectDeleted()
        ..massive = _massives.removeLast());
    }
  }
}

Massive _ConstMassive () => new Massive();
@PurityModel('Massive', _ConstMassive)
class Massive extends Model{
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

class TestView extends View{

  final List<MassiveView> _massives = new List<MassiveView>();
  int massivesToCreateToEnsureNoMemoryLeaks = massivesToCreateToEnsureCrash;

  TestView(src):super(src){
    _addEventHandlers();
  }

  _addEventHandlers(){
    listen(model, All, (Event e){
      lastEventDataCaughtByConsumer = e.data;
    });
    listen(model, MassiveObjectCreated, (Event<MassiveObjectCreated> e){
      _massives.add(new MassiveView(e.data.massive));
      Timer.run((){
        model.deleteAMassiveObject();
      });
    });
    listen(model, MassiveObjectDeleted, (Event<MassiveObjectDeleted> e){
      var massive = _massives.singleWhere((massive) => e.data.massive == massive.model);
      _massives.remove(massive);
      massive.dispose();
      if(massivesToCreateToEnsureNoMemoryLeaks-- > 0){
        model.createAMassiveObject();
      }else{
        memoryLeakTestComplete = true;
      }
    });
  }

  void doStuff(x){
    model.doStuff(x);
  }

  void callSourceMethod(Symbol name, [List<dynamic> posArgs]){
    posArgs = posArgs == null? []: posArgs;
    reflect(model).invoke(name, posArgs);
  }

  void callGetter(){
    return model.aGetter;
  }

  void callSetter(){
    model.aSetter = 1;
  }

  void runMemoryLeakSequence(){
    model.createAMassiveObject();
  }
}

class MassiveView extends View{
  MassiveView(src):super(src);
}


TestEvent _ConstTestEvent() => new TestEvent();
@PurityEventData('TestEvent', _ConstTestEvent)
class TestEvent extends EventData{
  dynamic get prop => get('prop');
  void set prop (o) => set('prop', o);
}

MassiveObjectDeleted _ConstMassiveObjectDeleted() => new MassiveObjectDeleted();
@PurityEventData('MassiveObjectDeleted', _ConstMassiveObjectDeleted)
class MassiveObjectDeleted extends MassiveObjectCreatedOrDeleted{}

MassiveObjectCreated _ConstMassiveObjectCreated() => new MassiveObjectCreated();
@PurityEventData('MassiveObjectCreated', _ConstMassiveObjectCreated)
class MassiveObjectCreated extends MassiveObjectCreatedOrDeleted{}

abstract class MassiveObjectCreatedOrDeleted extends EventData{
  dynamic get massive => get('massive');
  void set massive (o) => set('massive', o);
}

const int massivesToCreateToEnsureCrash = 50;
const int massiveSize = 1000000;
bool restrictedAccessMethodCalled = false;
bool memoryLeakTestComplete = false;
local.Server currentServer;
local.ViewEndPoint currentViewEndPoint;
TestModel currentTestSrc;
TestView currentTestConsumer;
dynamic srcPassedToConsumer;
dynamic lastErrorCaughtDuringTest;
dynamic lastEventDataCaughtByConsumer;

void _setUp(){

  runZoned((){
    currentServer = new local.Server(
      (_) => new Future.delayed(new Duration(), () => currentTestSrc = new TestModel()),
      (src) => new Future.delayed(new Duration(), (){}),
      1);

    local.initConsumerSettings(
      (src, proxyEndPoint){
        currentViewEndPoint = proxyEndPoint;
        currentTestConsumer = new TestView(src);
      },
      (){});

    currentServer.createEndPointPair();
    },
    onError:(error){
      lastErrorCaughtDuringTest = error;
    });
}

void _tearDown(){
  currentServer.shutdown();
  local.clearConsumerSettings();
  currentServer = currentTestSrc = currentTestConsumer =
  srcPassedToConsumer = lastEventDataCaughtByConsumer =
  lastErrorCaughtDuringTest = null;
  restrictedAccessMethodCalled = false;
}