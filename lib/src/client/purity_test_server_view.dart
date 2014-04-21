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
  
  final StackPanel _root =
    new StackPanel.horizontal()
    ..style.width = '100%'
    ..style.height = '100%';
  
  final StackPanel _serverStack =
    new StackPanel.vertical()
    ..style.width = 'calc(50% - 1px)'
    ..style.height = '100%';
  final StackPanel _serverHeaderStack =
    new StackPanel.horizontal()
    ..style.width = '100%'
    ..style.height = '30px'
    ..style.background = '#9AF';
  final Label _serverLabel = new Label('Purity Server: ');
  final Button _newClientButton =
    new Button.text('New Client');
  final StackPanel _serverMessageStack =
    new StackPanel.vertical()
    ..style.width = '100%'
    ..style.height = 'calc(100% - 31px)'
    ..style.overflow = 'auto'
    ..style.background = '#000'
    ..style.color = '#9AF';
  final StackPanel _clientStack =
    new StackPanel.vertical()
    ..style.width = 'calc(50% - 1px)'
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
      _serverMessageStack.add(new Label(msg));
    });
    _newClientButton.onClick.listen((_){server.simulateNewClient();});
  }
  
  void addNewClientView(Element el){
    _clientStack.add(new _ClientControlWrapper(el));
  } 
}

class _ClientControlWrapper extends Base{
  _ClientControlWrapper(Element el){
    html.append(el);
  }
}