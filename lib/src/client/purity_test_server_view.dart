/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.client;

/**
 * Acts as a basic view for running a purity server on the client side
 * to enable the user to launch multiple clients and debug communications.
 * This is intended to be a temporary solution until an angular component
 * can be made to replace it.
 */
class PurityTestServerView extends PurityModelConsumer{
  
  PurityTestServer get server => model;
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
  final Label _serverLabel = new Label('Purity Server: ');
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
  
  PurityTestServerView(server):super(server){
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
    listen(server, PurityServerMessageEvent, (PurityServerMessageEvent event){
      String msg;
      if(event.clientToServer){
        msg = '${event.sessionName} -> Server: ${event.tranString}';
      }else{
        msg = 'Server -> ${event.sessionName}: ${event.tranString}';
      }
      _writeMessage(msg);
    });
    listen(server, PurityAppSessionShutdownEvent, (event){
      _writeMessage('"${event.emitter.name}" Purity App Session Shutdown');
    });
    _newClientButton.onClick.listen((_){server.simulateNewClient();});
  }
  
  void addNewClientView(PurityClientCore clientCore, Element appHtmlRoot){
    _clientStack.add(new _ClientWindow(clientCore, appHtmlRoot));
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