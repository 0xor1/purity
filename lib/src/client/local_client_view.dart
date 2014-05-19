/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.client;

class _LocalClientView extends core.Consumer{

  static const String CLASS = 'purity-client-window';

  final DivElement html = new DivElement();

  final StackPanel _containerStack =
    new StackPanel.vertical()
    ..style.width = '100%'
    ..style.height = '100%';
  final StackPanel _headerStack =
    new StackPanel.horizontal()
    ..style.width = '100%'
    ..style.height = '30px'
    ..style.background = LocalHostView.color;
  final StackPanel _clientContainer =
    new StackPanel.vertical()
    ..style.width = '100%'
    ..style.height = 'calc(100% - 30px)'
    ..style.overflow = 'auto';


  _LocalClientView(local.ProxyEndPoint proxyEndPoint, Element el)
  :super(proxyEndPoint){
    _clientWindowStyle.insert();
    html.classes.add(CLASS);
    html.append(_containerStack.html);
    _headerStack.add(new Label(proxyEndPoint.name));
    _containerStack
    ..add(_headerStack)
    ..add(
      _clientContainer
      ..add(new _ClientControlWrapper(el)));
    _headerStack.html.onDoubleClick.listen((_){ //temporary, add in a X to close the client window.
      (source as local.ProxyEndPoint).shutdown();
      if(html.parent != null){
        html.parent.children.remove(html);
      }
      dispose();
    });
  }

  static final Style _clientWindowStyle = new Style('''

    .$CLASS
    {
      display: inline-block;
      position: relative;
      margin: 0;
      border: 0;
      padding: 0;
      width: 100%;
      height: 100%;
    }
  
  ''');
}

class _ClientControlWrapper extends Base{
  _ClientControlWrapper(Element el){
    html.append(el);
    html
    ..style.width = '100%'
    ..style.height = '100%';
  }
}