/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.core;

class ServerMessageEvent extends Event implements IServerMessageEvent{}
abstract class IServerMessageEvent{
  String sessionName;
  bool isClientToServer;
  String tranString;
}