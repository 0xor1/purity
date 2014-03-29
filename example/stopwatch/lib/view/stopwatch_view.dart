/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library StopwatchView;

import 'package:purity/purity_client.dart';
import '../interface/i_stopwatch.dart';

class StopwatchView extends View{

  final IStopwatch _stopwatch;
  final DivElement _duration =
    new DivElement()
    ..classes.add('duration');
  final ButtonElement _startStopButton =
    new ButtonElement()
    ..text = 'Start/Stop';
  final DivElement _buttons =
    new DivElement()
    ..classes.add('buttons');

  StopwatchView(IStopwatch this._stopwatch){

    html = new DivElement()
    ..classes.add('stopwatch')
    ..children.addAll([
      _duration,
      _buttons
      ..children.addAll([
        _startStopButton
      ])
    ]);

    _startStopButton.onClick.listen((e)=> _stopwatch.toggleStartStop());

    listen(_stopwatch, DurationChangeEvent, _handleDurationChangeEvent);

    _stopwatch.setTimeLimit(new Duration());

  }

  String _durationToDisplayString(Duration du){
    var seconds = du.inSeconds % 60;
    var minutes = du.inMinutes % 60;
    var hours = du.inHours;
    return '$hours:$minutes:$seconds';
  }

  void _handleDurationChangeEvent(DurationChangeEvent e){
    _duration.text = _durationToDisplayString(e.duration);
  }

}