/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of PurityServer;

final Logger _log = new Logger('Purity Server');

typedef Model AppInitialiser();

class PurityServer{

  static PurityServer _singleton;

  factory PurityServer(dynamic address, int port, String staticFileDirectory, AppInitialiser appInitialiser /*need to add app close handler*/){
    if(_singleton != null){
      return _singleton;
    }else{
      return new PurityServer._internal(address, port, staticFileDirectory, appInitialiser);
    }
  }

  PurityServer._internal(dynamic address, int port, String staticFileDirectory, AppInitialiser initialiseApp){

    _singleton = this;

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    if(!new Directory(staticFileDirectory).existsSync()) {
      _log.severe('The specified static file directory was not found: $staticFileDirectory');
      return;
    }

    HttpServer.bind(address, port).then((server) {

        _log.info("Server is running on "
                 "'http://${server.address.address}:$port/'");

        var router = new Router(server);

        router.serve(PURITY_SOCKET_ROUTE_PATH).listen((HttpRequest request){
          if(WebSocketTransformer.isUpgradeRequest(request)){
            var appModel = initialiseApp();
            var models = new Map<ObjectId, Model>();
            WebSocketTransformer.upgrade(request)
            .then((WebSocket ws){

              ValueProcessor processModel;
              processModel = (dynamic v){
                if(v is Model && !models.containsKey(v.id)){
                  models[v.id] = v;
                  v.addEventAction(Omni, (e) => ws.add(e.toTranString(processModel)));
                  return new ClientModel(v.id);
                }
                return v;
              };

              ws.map((str) => new Transmittable.fromTranString(str))
              .listen((InvocationEvent ie){
                var modelMirror = reflect(models[(ie.emitter as ModelBase).id]);
                modelMirror.invoke(ie.method, ie.positionalArguments, ie.positionalArguments);
              });

              var sessionInitTran = new SessionInitialisedTransmission()
              ..model = appModel;
              ws.add(sessionInitTran.toTranString(processModel));
            });
          }else{
            _log.warning("Purity app web socket request not valid");
            request.response.statusCode = HttpStatus.BAD_REQUEST;
            request.response.close();
          }
        });

        // Default handler serves files.
        var virDir = new http_server.VirtualDirectory(staticFileDirectory);
        virDir.jailRoot = true;
        virDir.allowDirectoryListing = false;
        virDir.directoryHandler = (dir, request) {
          // Redirect directory requests to index.html files.
          var indexUri = new Uri.file(dir.path).resolve('index.html');
          virDir.serveFile(new File(indexUri.toFilePath()), request);
        };

        // Add an error page handler.
        virDir.errorPageHandler = (HttpRequest request) {
          _log.warning("Resource not found: ${request.uri.path}");
          request.response.statusCode = HttpStatus.NOT_FOUND;
          request.response.close();
        };

        // Serve everything not routed elsewhere through the virtual directory.
        virDir.serve(router.defaultStream);
      });

  }
}
