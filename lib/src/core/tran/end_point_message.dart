/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

/// Emitted by [ModelEndPoint]s if the [Host] creating the [ModelEndPoint]s was constructed with verbose = true.
class EndPointMessage extends EventData{
  String get endPointName => get('endPointName');
  void set endPointName (String o){set('endPointName', o);}
  bool get isClientToServer => get('isClientToServer');
  void set isClientToServer (bool o){set('isClientToServer', o);}
  String get message => get('message');
  void set message (String o){set('message', o);}
}