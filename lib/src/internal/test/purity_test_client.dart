/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityInternal;

bool _hasTestAppViewInitialised = false;
InitAppView _initTestAppView;
OnConnectionClose _onTestConnectionClose;

void initPurityTestAppView(InitAppView initAppView, OnConnectionClose onConnectionClose){
  if(_hasTestAppViewInitialised){
    throw 'App view already initialised.';
  }
  if(PurityTestServer._singleton == null){
    throw 'PurityTestServer must be initialised before calling initPurityTestAppView.';
  }
  _hasTestAppViewInitialised = true;
  _initTestAppView = initAppView;
  _onTestConnectionClose = onConnectionClose;
}