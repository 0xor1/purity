/**
 * author: Daniel Robinson  http://github.com/0xor1
 *
 * N.B. this library is used both client and server side and so should not
 * under any circumstances reference dart:io or any client side libraries
 * e.g. dart:html.
 */

library PurityInternal;

import 'dart:mirrors';
import 'dart:async';
import 'package:bson/bson.dart' show ObjectId;
import 'package:eventable/eventable.dart';
import 'package:transmittable/transmittable.dart';

part 'purity_client_core.dart';
part 'purity_server_core.dart';
part 'purity_model_base.dart';
part 'purity_model.dart';
part 'purity_client_model.dart';
part 'purity_app_session.dart';
part 'purity_model_consumer.dart';
part 'purity_unsupported_invocation_type_error.dart';
part 'transmittable/purity_event.dart';
part 'transmittable/purity_invocation_event.dart';
part 'transmittable/purity_server_message_event.dart';
part 'transmittable/purity_transmission.dart';
part 'transmittable/purity_app_session_initialised_transmission.dart';
part 'transmittable/purity_garbage_collection_report_transmission.dart';
part 'transmittable/purity_garbage_collection_start_transmission.dart';
part 'test/purity_test_server.dart';
part 'test/purity_test_client.dart';
part 'test/stream_pack.dart';

const String PURITY_SOCKET_ROUTE_PATH = '/purity_socket';

typedef PurityModelBase OpenApp();
typedef void CloseApp(PurityModel m);
typedef dynamic InitAppView(PurityModelBase model);
typedef void OnConnectionClose();
typedef void SendString(String data);
typedef void SendTran(Transmittable data);

bool _purityTranTypesRegistered = false;
void _registerPurityTranTypes(){
  if(_purityTranTypesRegistered){ return; }
  _purityTranTypesRegistered = true;
  registerTranTypes('Purity', 'p', (){
    registerTranCodec('a', PurityClientModel, (PurityClientModel cm) => cm.purityId.toHexString(), (String s) => new PurityClientModel(new ObjectId.fromHexString(s)));
    registerTranSubtype('b', PurityInvocationEvent);
    registerTranSubtype('c', PurityServerMessageEvent);
    registerTranSubtype('d', PurityAppSessionInitialisedTransmission);
    registerTranSubtype('e', PurityGarbageCollectionReportTransmission);
    registerTranSubtype('f', PurityGarbageCollectionStartTransmission);
  });
}