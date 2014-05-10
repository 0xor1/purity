/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.client;

import 'dart:html';
export 'dart:html';
import 'core.dart' as core;
import 'local.dart' as local;
import 'package:controls_and_panels/controls_and_panels.dart';

part 'src/client/local_host_view.dart';
part 'src/client/local_client_view.dart';

void initConsumerSettings(core.InitConsumer initCon, core.Action onConnectionClose, String protocol){
  core.initConsumerSettings(initCon, onConnectionClose);
  var ws = new WebSocket('$protocol://${Uri.base.host}:${Uri.base.port}${core.PURITY_WEB_SOCKET_ROUTE_PATH}');
  ws.onOpen.first.then((_){
    var biConnection = new core.EndPointConnection(ws.onMessage.map((msg) => msg.data), ws.sendString, ws.close);
    new core.ProxyEndPoint(initCon, onConnectionClose, biConnection);
  });
}