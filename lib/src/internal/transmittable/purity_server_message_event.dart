/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class PurityServerMessageEvent extends PurityEvent implements IPurityServerMessageEvent{}
abstract class IPurityServerMessageEvent{
  String tranString;
  String sessionName;
  bool clientToServer;
}