/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.server;

import 'dart:io';
import 'dart:async';
import 'core.dart' as core;
import 'package:http_server/http_server.dart' as http_server;
import 'package:route/server.dart' show Router;
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

final Logger _log = new Logger('Purity Host');

class Server extends core.ServerCore{

  final dynamic address;
  final int port;
  final String staticFileDirectory;
  final int backlog;
  final String certificateName;
  final bool requestClientCertificate;


  Server(dynamic this.address, int this.port, String this.staticFileDirectory, core.SeedApplication seedApplication, {core.CloseSource closeSrc: null, int gcFreq: 0, bool verbose: false, this.backlog: 0, this.certificateName: null, this.requestClientCertificate: false}):
    super(seedApplication, closeSrc, gcFreq, verbose);

  Future<Router> start(){

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}: ${rec.message}');
    });

    if(!new Directory(staticFileDirectory).existsSync()) {
      throw new Exception('The specified static file directory was not found: $staticFileDirectory');
    }

    var serverFutureHandler = (server) {

      _log.info("Server is running on "
               "'http(s)://${server.address.address}:$port/'");

      var router = new Router(server);

      router.serve(core.PURITY_WEB_SOCKET_ROUTE_PATH).listen((HttpRequest request){
        if(WebSocketTransformer.isUpgradeRequest(request)){
          WebSocketTransformer.upgrade(request)
          .then((ws){
            var biConnection = new core.EndPointConnection(ws, ws.add, ws.close);
            createSourceEndPoint(request.connectionInfo.remoteAddress.toString(), biConnection);
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

      return router;
    };

    if(certificateName == null){
      return HttpServer.bind(address, port, backlog: backlog).then(serverFutureHandler);
    }else{
      return HttpServer.bindSecure(address, port, backlog: backlog, certificateName: certificateName, requestClientCertificate: requestClientCertificate).then(serverFutureHandler);
    }
  }
}

