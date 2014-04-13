/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

class PurityServerMessageEvent extends PurityEvent implements IPurityServerMessageEvent{}
abstract class IPurityServerMessageEvent{
  String tranString;
  String sessionName;
  bool clientToServer;
}