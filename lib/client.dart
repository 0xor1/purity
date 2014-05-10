/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.client;

import 'dart:html';
export 'dart:html';
import 'core.dart' as core;

void initConsumerSettings(core.InitConsumer initCon, core.Action onConnectionClose, String protocol){
  core.initConsumerSettings(initCon, onConnectionClose);
  var ws = new WebSocket('$protocol://${Uri.base.host}:${Uri.base.port}${core.PURITY_WEB_SOCKET_ROUTE_PATH}');
  ws.onOpen.first.then((_){
    var biConnection = new core.EndPointConnection(ws.onMessage.map((msg) => msg.data), ws.sendString, ws.close);
    new core.ProxyEndPoint(initCon, onConnectionClose, biConnection);
  });
}