/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class ProxyEndPointCreatedEvent extends core.Event implements IProxyEndPointCreatedEvent{}
abstract class IProxyEndPointCreatedEvent{
  ProxyEndPoint proxyEndPoint;  
}