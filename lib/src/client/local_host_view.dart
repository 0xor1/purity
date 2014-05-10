/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.client;

/**
 * Acts as a basic view for running a purity server on the client side
 * to enable the user to launch multiple clients and debug communications.
 * This is intended to be a temporary solution until an angular component
 * can be made to replace it.
 */
class LocalHostView extends core.Consumer{
  
  local.Host get host => source;
  static const String color = '#9AF';
  static const String background = '#000';
  
  final StackPanel _root =
    new StackPanel.horizontal()
    ..style.width = '100%'
    ..style.height = '100%';
  
  final StackPanel _serverStack =
    new StackPanel.vertical()
    ..style.width = '50%'
    ..style.height = '100%';
  final StackPanel _serverHeaderStack =
    new StackPanel.horizontal()
    ..style.width = '100%'
    ..style.height = '30px'
    ..style.background = color;
  final Label _serverLabel = new Label('Host: ');
  final Button _newClientButton =
    new Button.text('New Client');
  final StackPanel _serverMessageStack =
    new StackPanel.vertical()
    ..style.width = '100%'
    ..style.height = 'calc(100% - 30px)'
    ..style.overflow = 'auto'
    ..style.background = background
    ..style.color = color;
  final StackPanel _clientStack =
    new StackPanel.vertical()
    ..style.width = '50%'
    ..style.height = '100%'
    ..style.overflow = 'auto';
  
  DivElement get html => _root.html;
  
  LocalHostView(server):super(server){
    _root
    ..add(
      _serverStack
      ..add(
        _serverHeaderStack
        ..add(_serverLabel)
        ..add(_newClientButton))
      ..add(_serverMessageStack))
    ..add(_clientStack);
    
    _hookUpEvents();
  }
 
  void _hookUpEvents(){
    listen(host, core.EndPointMessageEvent, (core.EndPointMessageEvent event){
      String msg;
      if(event.isProxyToSource){
        msg = '${event.endPointName} -> Host: ${event.message}';
      }else{
        msg = 'Host -> ${event.endPointName}: ${event.message}';
      }
      _writeMessage(msg);
    });
    _newClientButton.onClick.listen((_){ host.createEndPointPair(); });
  }
  
  void addNewClientView(local.ProxyEndPoint proxyEndPoint, Element appHtmlRoot){
    _clientStack.add(new _LocalClientView(proxyEndPoint, appHtmlRoot));
    _clientStack.items.last.html.scrollIntoView(ScrollAlignment.BOTTOM);
  } 
  
  void _writeMessage(String msg){
    var label = new Label(msg);
    _serverMessageStack.add(label);
    label.html.scrollIntoView(ScrollAlignment.BOTTOM);
    _serverMessageStack.addSplitter(lineColor: background, beforeMargin: 5, afterMargin: 5);
    if(_serverMessageStack.items.length >= 300){
      _serverMessageStack.remove(_serverMessageStack.items[0]);
      _serverMessageStack.remove(_serverMessageStack.items[0]);
    }
  }
}