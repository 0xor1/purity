/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class ViewEndPoint extends core.ViewEndPoint{
  final String name;
  ViewEndPoint(this.name, core.InitConsumer initConsumption, core.EndPointConnection connection, [core.Action onCloseConnection = null]):
    super(initConsumption, connection, onCloseConnection);
}