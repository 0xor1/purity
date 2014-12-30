/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class ProxyEndPointCreated extends core.EventData{
  ProxyEndPoint get proxyEndPoint => get('proxyEndPoint');
  void set proxyEndPoint (ProxyEndPoint o) => set('proxyEndPoint', o);
}