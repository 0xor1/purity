/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

part of purity.server;

final Logger _log = new Logger('Purity Server');

class PurityServer{

  final PurityServerCore _purityServerCore;

  factory PurityServer(dynamic address, int port, String staticFileDirectory, OpenApp openApp, CloseApp closeApp, [int garbageCollectionFrequency = 60]){
    return new PurityServer._internal(address, port, staticFileDirectory, new PurityServerCore(openApp, closeApp, garbageCollectionFrequency));
  }

  PurityServer._internal(dynamic address, int port, String staticFileDirectory, PurityServerCore this._purityServerCore){

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
            WebSocketTransformer.upgrade(request)
            .then((ws){
              _purityServerCore.createPurityAppSession(request.connectionInfo.remoteAddress.toString(), ws, ws.add, ws.close);
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
        virDir.allowDirectoryListing = true;
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
