/**
 * author: Daniel Robinson http://github.com/0xor1
 */

library purity.server;

import 'dart:io';
import 'core.dart';
import 'package:http_server/http_server.dart' as http_server;
import 'package:route/server.dart' show Router;
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

part 'src/remote/server.dart';
