/**
 * Author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

class ProxyEndPointCreated extends core.EventData{
  ViewEndPoint get proxyEndPoint => get('proxyEndPoint');
  void set proxyEndPoint (ViewEndPoint o) => set('proxyEndPoint', o);
}