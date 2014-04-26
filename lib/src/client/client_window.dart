/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.client;

class _ClientWindow extends Control{
  
  static const String CLASS = 'purity-client-window';
  
  final StackPanel _containerStack =
    new StackPanel.vertical()
    ..style.width = '100%'
    ..style.height = '100%';
  final StackPanel _headerStack = 
    new StackPanel.horizontal()
    ..style.width = '100%'
    ..style.height = '30px'
    ..style.background = PurityTestServerView.color;
  final SizerPanel _clientContainer = 
    new SizerPanel('100%', 'calc(100% - 30px)')
    ..style.overflow = 'auto';
  
  
  _ClientWindow(String clientName, Element el){
    _clientWindowStyle.insert();
    html.classes.add(CLASS);
    html.append(_containerStack.html);
    _headerStack.add(new Label(clientName));
    _containerStack
    ..add(_headerStack)
    ..add(
      _clientContainer
      ..add(new _ClientControlWrapper(el)));
  }
  
  static final Style _clientWindowStyle = new Style('''

    .$CLASS
    {
      width: 100%;
      height: 100%;
    }
  
  ''');
}

class _ClientControlWrapper extends Base{
  _ClientControlWrapper(Element el){
    html.append(el);
  }
}