/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library purity.core;

import 'dart:mirrors';
import 'dart:async';
import 'package:bson/bson.dart' show ObjectId;
import 'package:eventable/eventable.dart';
import 'package:transmittable/transmittable.dart';

part 'src/core/base.dart';
part 'src/core/source.dart';
part 'src/core/source_manager.dart';
part 'src/core/proxy.dart';
part 'src/core/proxy_manager.dart';
part 'src/core/consumer.dart';
part 'src/core/bi_connection.dart';
part 'src/core/i_manager.dart';

part 'src/core/tran/event.dart';
part 'src/core/tran/proxy_invocation.dart';
part 'src/core/tran/transmission.dart';
part 'src/core/tran/source_ready.dart';
part 'src/core/tran/garbage_collection_report.dart';
part 'src/core/tran/garbage_collection_start.dart';

part 'src/core/unsupported_proxy_invocation_error.dart';
part 'src/core/unsupported_message_type_error.dart';

typedef void Action();
typedef void SendString(String str);
typedef void (SourceManager srcManager);
typedef void CloseApp(PurityModel m);
typedef void InitAppView(_Base model);

bool _purityTranTypesRegistered = false;
void _registerPurityTranTypes(){
  if(_purityTranTypesRegistered){ return; }
  _purityTranTypesRegistered = true;
  registerTranTypes('purity.core', 'p.c', (){
    registerTranCodec('a', _Proxy, (_Proxy p) => p._purityId.toHexString(), (String s) => new _Proxy(new ObjectId.fromHexString(s)));
    registerTranSubtype('b', _ProxyInvocation);
    registerTranSubtype('d', _SourceReady);
    registerTranSubtype('e', _GarbageCollectionReport);
    registerTranSubtype('f', _GarbageCollectionStart);
  });
}