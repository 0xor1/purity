/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.test.utility;

import 'package:unittest/unittest.dart';
import 'dart:async';

void executeWhenReadyOrTimeout(bool readyCheck(), void execute(), [int timeout = 1, void onTimeout() = null]){
  DateTime end = new DateTime.now().add(new Duration(seconds: timeout));
  var inner;
  inner = (){
    if(readyCheck()){
      execute();
    }else if(new DateTime.now().isAfter(end)){
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
  DateTime end = new DateTime.now().add(new Duration(seconds: timeout));
  var inner;
  inner = (){
    if(readyCheck()){
      expect();
    }else if(new DateTime.now().isAfter(end)){
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