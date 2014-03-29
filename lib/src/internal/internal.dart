/**
 * author: Daniel Robinson  http://github.com/0xor1
 *
 * N.B. this library is used both client and server side and so should not
 * under any circumstances reference dart:io or any client side libraries
 * e.g. dart:html.
 */

library Internal;

import 'dart:mirrors';
import 'package:bson/bson.dart' show ObjectId;
import 'package:eventable/eventable.dart';
import 'package:transmittable/transmittable.dart';

part 'model_base.dart';
part 'model.dart';
part 'invocation_event.dart';
part 'client_model.dart';
part 'session_initialised_transmission.dart';
part 'unsupported_invocation_type_error.dart';

const String PURITY_SOCKET_ROUTE_PATH = '/purity_socket';

const String CLIENT_MODEL_TRAN_KEY = 'cm';

bool _registeredTranTypes = false;
void _registerTranTypes(){
  if(_registeredTranTypes){ return; }
  _registeredTranTypes = true;
  registerTranCodec(CLIENT_MODEL_TRAN_KEY, ClientModel, (ClientModel cm) => cm.id.toHexString(), (String s) => new ClientModel(new ObjectId.fromHexString(s)));
  registerTranSubtype('pie', InvocationEvent);
  registerTranSubtype('psit', SessionInitialisedTransmission);
}

