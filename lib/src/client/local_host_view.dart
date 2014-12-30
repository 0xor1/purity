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
class LocalHostView extends core.View{

  static const String COMMUNICATIONS = 'purity-local-host-view-communications';

  local.Host get host => model;

  cnp.CommandLine _cmdLn;
  cnp.CommandLineInputBinder _binder;
  cnp.PagePanel _page;
  cnp.CommandLine _coms;
  cnp.Window _comsWindow;
  final Map<String, cnp.Window> _clientWindows = new Map<String, cnp.Window>();
  final Map<String, local.ProxyEndPoint> _clientEndPoints = new Map<String, local.ProxyEndPoint>();

  DivElement get html => _page.html;

  LocalHostView(local.Host host):super(host){
    _localHostViewStyle.insert();
    _cmdLn = new cnp.CommandLine()
    ..enterText('Enter showComs to display a window showing all communications to/from the Purity Host.')
    ..enterText('Enter newClient to simulate a new client connecting to the host.')
    ..enterText('Enter closeClient # to simulate the client with id # closing down.')
    ..fill();
    _binder = new cnp.CommandLineInputBinder(_cmdLn);
    _page = new cnp.PagePanel(_cmdLn);
    _coms = new cnp.CommandLine()..fill()..disableUserInput()..addClass(COMMUNICATIONS);
    _comsWindow = new cnp.Window(_coms, 'Host_Coms', 200, 200, 0, 0);
    _addCommandBindings();
    _hookUpEvents();
  }

  void _hookUpEvents(){
    listen(host, core.EndPointMessage, (core.Event<core.EndPointMessage> event){
      var msg = event.data;
      String str;
      if(msg.isClientToServer){
        str = 'EP#${msg.endPointName} -> Host: ${msg.message}';
      }else{
        str = 'Host -> EP#${msg.endPointName}: ${msg.message}';
      }
      _coms.enterText(str);
    });
  }

  void _addCommandBindings(){
    _binder.addAll([
      new cnp.CommandLineBinding(
        'newClient',
        'Simulates a new client browsing to the Host',
        (cnp.CommandLine cmdLn, List<String> posArgs, Map<String, String> namArgs){
          host.createEndPointPair();
        }),
      new cnp.CommandLineBinding(
        'closeClient',
        'Simulates the specified client closing the page, example close client 1: > closeClient 1',
        (cnp.CommandLine cmdLn, List<String> posArgs, Map<String, String> namArgs){
          if(posArgs.length > 0 && _clientWindows.containsKey(posArgs[0])){
            _clientWindows.remove(posArgs[0]).hide();
            _clientEndPoints.remove(posArgs[0]).shutdown();
          }
        }),
      new cnp.CommandLineBinding(
        'showComs',
        'Shows the communications window',
        (cnp.CommandLine cmdLn, List<String> posArgs, Map<String, String> namArgs){
          _comsWindow.show();
        }),
      new cnp.CommandLineBinding(
        'hideComs',
        'Hides the communications window',
        (cnp.CommandLine cmdLn, List<String> posArgs, Map<String, String> namArgs){
          _comsWindow.hide();
        }),
    ]);
  }

  void addNewClientView(local.ProxyEndPoint proxyEndPoint, Element appHtmlRoot, [int width = 200, int height = 200, int top = 0, int left = 0]){
    _clientEndPoints[proxyEndPoint.name] = proxyEndPoint;
    _clientWindows[proxyEndPoint.name] =
      new cnp.Window(
        new cnp.Wrapper.ForElement(appHtmlRoot)
        ..fill()
        ..style.overflow = 'auto',
        proxyEndPoint.name, width, height, top, left)..show();
  }

  static final cnp.Style _localHostViewStyle = new cnp.Style('''

    .${cnp.CommandLine.CLASS}.${COMMUNICATIONS}
      > .${cnp.StackPanel.CLASS} *
    {
      background: #fff;
      color: #000;
      font-family: "Lucida Console", Monaco, monospace;
      font-size: 14px;
    }
    
  ''');
}