/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.internal;

class _StreamPack<T>{
  final StreamController<T> controller = new StreamController<T>();
  Stream<T> _stream;
  Stream<T> get stream => _stream != null? _stream: _stream = controller.stream.asBroadcastStream();
}

