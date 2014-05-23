/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.test.utility;

import 'package:unittest/unittest.dart';
import 'dart:async';

typedef void Action();

void executeWhenReadyOrTimeout(bool readyCheck(), void execute(), [int timeout = 1, void onTimeout() = null]){
  _runAsyncWithReadyCheckAndTimeout(readyCheck, execute, (fn) => fn, timeout, onTimeout);
}

void expectAsyncWithReadyCheckAndTimeout(bool readyCheck(), void expect(), [int timeout = 1, void onTimeout() = null]){
  _runAsyncWithReadyCheckAndTimeout(readyCheck, expect, (fn) => expectAsync(fn), timeout, onTimeout);
}

void _runAsyncWithReadyCheckAndTimeout(bool readyCheck(), void execute(), Action nextIter(Action action), int timeout, void onTimeout()){
  DateTime end = new DateTime.now().add(new Duration(seconds: timeout));
  var inner;
  inner = (){
    if(readyCheck()){
      execute();
    }else if(new DateTime.now().isAfter(end)){
      if(onTimeout == null){
        throw 'async test timed out.';
      }else{
        onTimeout();
      }
    }else{
      Timer.run(nextIter(inner));
    }
  };
  inner();
}