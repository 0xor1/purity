/**
 * author: Daniel Robinson http://github.com/0xor1
 */

part of purity.local;

class EndPointConnectionPair{
  
  final StreamController<String> _controllerA = new StreamController<String>();
  Stream<String> _streamAStore;
  Stream<String> get _streamA => _streamAStore != null? _streamAStore: _streamAStore = _controllerA.stream.asBroadcastStream();
  
  final StreamController<String> _controllerB = new StreamController<String>();
  Stream<String> _streamBStore;
  Stream<String> get _streamB => _streamBStore != null? _streamBStore: _streamBStore = _controllerB.stream.asBroadcastStream();
  
  core.EndPointConnection _a;
  core.EndPointConnection get a => _a;
  
  core.EndPointConnection _b;
  core.EndPointConnection get b => _b;
  
  EndPointConnectionPair(){
    _a = new core.EndPointConnection(_streamB, _controllerA.add, _controllerA.close);
    _b = new core.EndPointConnection(_streamA, _controllerB.add, _controllerB.close);
  }
  
}