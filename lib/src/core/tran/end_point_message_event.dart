/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class EndPointMessageEvent extends Event implements IEndPointMessageEvent{}
abstract class IEndPointMessageEvent{
  String sessionName;
  bool isIncoming;
  String message;
}