/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

bool hasTestAppViewInitialised = false;
dynamic initTestAppView;
Action onTestConnectionClose;

void initPurityTestAppView(InitAppView initAppView, Action onConnectionClose){
  if(hasTestAppViewInitialised){
    throw 'App view already initialised.';
  }
  hasTestAppViewInitialised = true;
  initTestAppView = initAppView;
  onTestConnectionClose = onConnectionClose;
}