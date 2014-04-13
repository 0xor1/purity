/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityClient;

bool _hasInitialised = false;

void initPurityAppView(InitAppView initAppView, OnConnectionClose onConnectionClose){
  if(_hasInitialised){
    throw 'App view already initialised.';
  }
  _hasInitialised = true;
  var ws = new WebSocket('ws://${Uri.base.host}:${Uri.base.port}$PURITY_SOCKET_ROUTE_PATH');
  ws.onOpen.first.then((_) =>
    new PurityClientCore(initAppView, onConnectionClose, ws.onMessage, ws.sendString));
}