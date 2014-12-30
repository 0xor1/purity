/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _ProxyInvocation extends _Transmission{
  Model get src => get('src');
  void set src (Model o){set('src', o);}
  String get method => get('method');
  void set method (String o){set('method', o);}
  List<dynamic> get posArgs => get('posArgs');
  void set posArgs (List<dynamic> o){set('posArgs', o);}
  Map<String, dynamic> get namArgs => get('namArgs');
  void set namArgs (Map<String, dynamic> o){set('namArgs', o);}
}