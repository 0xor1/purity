/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library IStopwatch;

import 'package:purity/purity.dart';

part 'duration_change_event.dart';

abstract class IStopwatch implements EventEmitter{
  void toggleStartStop();
  void setTimeLimit(Duration du);
  void clearTimeLimit();
}

bool _tranTypesRegistered = false;
void registerTranTypes(){
  if(_tranTypesRegistered){ return; }
  _tranTypesRegistered = true;
  registerTranSubtype('dce', DurationChangeEvent);
}