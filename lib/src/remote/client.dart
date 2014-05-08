/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.client;

bool _hasInitialised = false;

void initPurityAppView(String protocol, InitAppView initAppView, Action onConnectionClose){
  if(_hasInitialised){
    throw 'App view already initialised.';
  }
  _hasInitialised = true;
  var ws = new WebSocket('$protocol://${Uri.base.host}:${Uri.base.port}$PURITY_SOCKET_ROUTE_PATH');
  ws.onOpen.first.then((_) =>
    new PurityClientCore('', initAppView, onConnectionClose, ws.onMessage.map((msg) => msg.data), ws.sendString, ws.close));
}