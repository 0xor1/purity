/**
 * author: Daniel Robinson  http://github/0xor1
 */

library purity.client;

import 'dart:html';
export 'dart:html';
import 'core.dart' as core;

void initConsumptionSettings(core.InitConsumption initCon, core.Action onConnectionClose, String protocol){
  core.initConsumptionSettings(initCon, onConnectionClose);
  var ws = new WebSocket('$protocol://${Uri.base.host}:${Uri.base.port}${core.PURITY_SOCKET_ROUTE_PATH}');
  ws.onOpen.first.then((_){
    var biConnection = new core.BiConnection(ws.onMessage.map((msg) => msg.data), ws.sendString, ws.close);
    new core.ProxyManager(initCon, onConnectionClose, biConnection);
  });
}