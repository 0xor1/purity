/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.core;

class _ProxyInvocation extends _Transmission{
  Source get src => get('src');
  void set src (Source o) => set('src', o);
  Symbol get method => get('method');
  void set method (Symbol o) => set('method', o);
  List<dynamic> get posArgs => get('posArgs');
  void set posArgs (List<dynamic> o) => set('posArgs', o);
  Map<Symbol, dynamic> get namArgs => get('namArgs');
  void set namArgs (Map<Symbol, dynamic> o) => set('namArgs', o);
}