/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of IStopwatch;

class DurationChangeEvent extends Event implements IDurationChangeEvent{}
abstract class IDurationChangeEvent{
  Duration duration;
}