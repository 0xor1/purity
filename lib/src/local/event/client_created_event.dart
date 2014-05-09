/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class ClientCreatedEvent extends core.Event implements IClientCreatedEvent{}
abstract class IClientCreatedEvent{
  String name;
  core.ProxyManager proxyManager;  
}