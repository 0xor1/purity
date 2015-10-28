/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Emitted by [SourceEndPoint]s if the [Host] creating the [SourceEndPoint]s was constructed with verbose = true.
class EndPointMessage extends Transmittable{
  String get endPointName => get('endPointName');
  void set endPointName (String o) => set('endPointName', o);
  bool get isProxyToSource => get('isProxyToSource');
  void set isProxyToSource (bool o) => set('isProxyToSource', o);
  String get message => get('message');
  void set message (String o) => set('message', o);
}