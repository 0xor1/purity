/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class ProxyEndPoint extends core.ProxyEndPoint{
  final String name;
  ProxyEndPoint(this.name, core.InitConsumption initConsumption, core.Action onCloseConnection, core.EndPointConnection connection):
    super(initConsumption, onCloseConnection, connection);
}