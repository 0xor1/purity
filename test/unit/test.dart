/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.test;

import 'package:unittest/unittest.dart';
import 'package:purity/purity.dart';
import 'package:purity/local.dart' as local;
import 'package:purity/core.dart' as core;
import 'dart:async';
import 'dart:math';

part 'end_to_end_test.dart';
part 'error_test.dart';

class TestSource extends Source{
  void doStuff(int x){
    emitEvent(
      new TestEvent()
      ..aFakeTestProp = x);
  }
}

class TestConsumer extends Consumer{
  TestConsumer(src):super(src){
    listen(src, Omni, (event){
      lastEventCaughtByConsumer = event;
    });
  }
  
  doStuff(int x){
    source.doStuff(x);
  }
}

class TestEvent extends Event implements ITestEvent{}
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

local.Host currentHost;
local.ProxyEndPoint currentproxyEndPoint;
TestSource currentTestSrc;
TestConsumer currentTestConsumer;
dynamic srcPassedToConsumer;
TestEvent lastEventCaughtByConsumer;

void executeWhenReadyOrTimeout(bool readyCheck(), void execute(), [int timeout = 1, void onTimeout() = null]){
  DateTime start = new DateTime.now();
  Duration limit = new Duration(seconds: timeout);
  var inner;
  inner = (){
    if(readyCheck()){
      execute();
    }else if(new DateTime.now().subtract(limit).isAfter(start)){
      if(onTimeout == null){
        throw 'execute timed out.';
      }else{
        onTimeout();
      }
    }else{
      Timer.run(inner);
    }
  };
  inner();
}

void expectAsyncWithReadyCheckAndTimeout(bool readyCheck(), void expect(), [int timeout = 1, void onTimeout() = null]){
  DateTime start = new DateTime.now();
  Duration limit = new Duration(seconds: timeout);
  var inner;
  inner = (){
    if(readyCheck()){
      expect();
    }else if(new DateTime.now().subtract(limit).isAfter(start)){
      if(onTimeout == null){
        throw 'async test timed out.';
      }else{
        onTimeout();
      }
    }else{
      Timer.run(expectAsync(inner));
    }
  };
  inner();
}

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
  currentHost = currentTestSrc = currentTestConsumer = srcPassedToConsumer = lastEventCaughtByConsumer = null;
}

void main(){  
  _registerPurityTestTranTypes();
  setUp(_setUp);
  tearDown(_tearDown);
  _runCoreTests();
  _runErrorTests();
}