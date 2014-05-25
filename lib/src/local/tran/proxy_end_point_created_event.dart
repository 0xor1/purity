/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class ProxyEndPointCreated extends core.Transmittable implements IProxyEndPointCreated{}
abstract class IProxyEndPointCreated{
  ProxyEndPoint proxyEndPoint;
}