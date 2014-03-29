/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library StopwatchLocalTest;

import 'dart:html';
import '../lib/model/stopwatch.dart' as SW;
import '../lib/view/stopwatch_view.dart';

void main(){
  var model = new SW.Stopwatch();
  var view = new StopwatchView(model);
  document.body.children.add(view.html);
}