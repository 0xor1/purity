/**
 * autho: Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class BiConnectionPair{
  
  final StreamController<String> _controllerA = new StreamController<String>();
  Stream<String> _streamAStore;
  Stream<String> get _streamA => _streamA != null? _streamAStore: _streamAStore = _controllerA.stream.asBroadcastStream();
  
  final StreamController<String> _controllerB = new StreamController<String>();
  Stream<String> _streamBStore;
  Stream<String> get _streamB => _streamB != null? _streamBStore: _streamBStore = _controllerB.stream.asBroadcastStream();
  
  core.BiConnection _a;
  core.BiConnection get a => _a;
  
  core.BiConnection _b;
  core.BiConnection get b => _b;
  
  BiConnectionPair(){
    _a = new core.BiConnection(_streamB, _controllerA.add, _controllerA.close);
    _a = new core.BiConnection(_streamA, _controllerB.add, _controllerB.close);
  }
  
}