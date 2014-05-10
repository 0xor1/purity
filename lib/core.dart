/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library purity.core;

import 'dart:mirrors';
import 'dart:async';
import 'package:bson/bson.dart' show ObjectId;
import 'package:eventable/eventable.dart';
export 'package:eventable/eventable.dart';
import 'package:transmittable/transmittable.dart';
export 'package:transmittable/transmittable.dart';

part 'src/core/base.dart';
part 'src/core/source.dart';
part 'src/core/source_end_point.dart';
part 'src/core/proxy.dart';
part 'src/core/proxy_end_point.dart';
part 'src/core/consumer.dart';
part 'src/core/end_point_connection.dart';
part 'src/core/end_point.dart';
part 'src/core/source_end_point_host.dart';

part 'src/core/tran/event.dart';
part 'src/core/tran/shutdown_event.dart';
part 'src/core/tran/end_point_message_event.dart';
part 'src/core/tran/proxy_invocation.dart';
part 'src/core/tran/transmission.dart';
part 'src/core/tran/ready.dart';
part 'src/core/tran/garbage_collection_report.dart';
part 'src/core/tran/garbage_collection_start.dart';

part 'src/core/error/unsupported_proxy_invocation_error.dart';
part 'src/core/error/unsupported_message_type_error.dart';
part 'src/core/error/consumption_settings_already_initialised_error.dart';
part 'src/core/error/denied_access_method_error.dart';

typedef void Action();
typedef void SendString(String str);
typedef void SendTran(Transmittable tran);
typedef Future<Source> InitSource(EndPoint srcEndPoint);
typedef Future<Source> CloseSource(Source src);
typedef void InitConsumption(_Proxy proxy, EndPoint proxyEndPoint);

const String PURITY_WEB_SOCKET_ROUTE_PATH = '/purity_socket';

Set<Symbol> _deniedAccessMethods = new Set<Symbol>();

void _setDeniedAccessMethods(){
  if(_deniedAccessMethods.isEmpty){
    _deniedAccessMethods.addAll(reflectClass(EventEmitter).instanceMembers.keys);
    _deniedAccessMethods.addAll(reflectClass(EventDetector).instanceMembers.keys);
  }
}

bool _consumptionSettingsInitialised = false;
InitConsumption _initConsumption;
Action _onConnectionClose;

bool get consumptionSettingsInitialised => _consumptionSettingsInitialised;
InitConsumption get initConsumption => _initConsumption;
Action get onConnectionClose => _onConnectionClose;

void initConsumptionSettings(InitConsumption initCon, Action onConnectionClose){
  if(_consumptionSettingsInitialised){
    throw new ConsumptionSettingsAlreadyInitialisedError();
  }
  _consumptionSettingsInitialised = true;
  _initConsumption = initCon;
  _onConnectionClose = onConnectionClose;
}

bool _purityCoreTranTypesRegistered = false;
void _registerPurityCoreTranTypes(){
  if(_purityCoreTranTypesRegistered){ return; }
  _purityCoreTranTypesRegistered = true;
  registerTranTypes('purity.core', 'pc', (){
    registerTranCodec('a', _Proxy, (_Proxy p) => p._purityId.toHexString(), (String s) => new _Proxy(new ObjectId.fromHexString(s)));
    registerTranSubtype('b', _ProxyInvocation);
    registerTranSubtype('d', _Ready);
    registerTranSubtype('e', _GarbageCollectionReport);
    registerTranSubtype('f', _GarbageCollectionStart);
    registerTranSubtype('g', ShutdownEvent);
    registerTranSubtype('h', EndPointMessageEvent);
  });
}