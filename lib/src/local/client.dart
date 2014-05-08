/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.local;

bool _hasLocalProxyInitialised = false;
InitProxy _initLocalProxy;
Action _onLocalConnectionClose;

void initLocalProxy(InitProxy initProxy, Action onConnectionClose){
  if(_hasLocalProxyInitialised){
    throw 'Local proxy already initialised.';
  }
  _hasLocalProxyInitialised = true;
  _initLocalProxy = initProxy;
  _onLocalConnectionClose = onConnectionClose;
}