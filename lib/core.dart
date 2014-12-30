/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

/// Contains the core Purity types to implement a single page web app
/// using the Purity pattern.
library purity.core;

@MirrorsUsed(targets: const[], override: '*')
import 'dart:mirrors';
import 'dart:async';
import 'package:bson/bson.dart' show ObjectId;
import 'package:emitters/emitters.dart';
import 'package:transmittable/transmittable.dart';
export 'package:emitters/emitters.dart';
export 'package:transmittable/transmittable.dart';

part 'src/core/model.dart';
part 'src/core/model_end_point.dart';
part 'src/core/view_end_point.dart';
part 'src/core/view.dart';
part 'src/core/end_point_connection.dart';
part 'src/core/end_point.dart';
part 'src/core/event_data.dart';
part 'src/core/host.dart';
part 'src/core/annotation.dart';

part 'src/core/tran/model_event.dart';
part 'src/core/tran/shutdown.dart';
part 'src/core/tran/end_point_message.dart';
part 'src/core/tran/proxy_invocation.dart';
part 'src/core/tran/transmission.dart';
part 'src/core/tran/app_ready.dart';
part 'src/core/tran/garbage_collection_report.dart';
part 'src/core/tran/garbage_collection_start.dart';

part 'src/core/error/invalid_init_source_return_type_error.dart';
part 'src/core/error/unsupported_message_type_error.dart';
part 'src/core/error/consumer_settings_already_initialised_error.dart';
part 'src/core/error/event_data_locked_error.dart';
part 'src/core/error/duplicated_purity_model_identifier_error.dart';
part 'src/core/error/duplicated_purity_method_identifier_error.dart';

typedef void Action();
typedef void SendString(String str);
typedef void SendTran(Transmittable tran);
typedef dynamic SeedApplication(_EndPoint srcEndPoint);
typedef dynamic CloseSource(Model seed);
typedef void InitConsumer(Model proxy, _EndPoint proxyEndPoint);
typedef void Adapter(List<dynamic> posArgs, Map<String, dynamic> namArgs);

const String PURITY_WEB_SOCKET_ROUTE_PATH = '/purity_socket';

bool _consumerSettingsInitialised = false;
InitConsumer _initConsumer;
Action _handleConnectionClose;

bool get consumerSettingsInitialised => _consumerSettingsInitialised;
InitConsumer get initConsumer => _initConsumer;
Action get hanleConnectionClose => _handleConnectionClose;

/**
 * Stores the [initConsumer] and [handleConnectionClose] to be called when the [ModelEndPoint] is ready,
 * and when the [EndPointConnection] to the [ModelEndPoint] is closed, respectively.
 *
 * Throws [ConsumerSettingsAlreadyInitialisedError] if called more than once.
 */
void initConsumerSettings(InitConsumer initConsumer, Action handleConnectionClose){
  if(_consumerSettingsInitialised){
    throw new ConsumerSettingsAlreadyInitialisedError();
  }
  _consumerSettingsInitialised = true;
  _initConsumer = initConsumer;
  _handleConnectionClose = handleConnectionClose;
}

/**
 * Clears the current set of consumer initialisation settings.
 *
 * This is only expected to be used in the unit testing of the purity.core library.
 */
void clearConsumerSettings(){
  _initConsumer = null;
  _handleConnectionClose = null;
  _consumerSettingsInitialised = false;
}

final Registrar _registerPurityCoreTranTypes = generateRegistrar(
    'purity/purity.core', 'p', [
    new TranRegistration.subtype(_ProxyInvocation, () => new _ProxyInvocation()),
    new TranRegistration.subtype(_AppReady, () => new _AppReady()),
    new TranRegistration.subtype(_GarbageCollectionReport, () => new _GarbageCollectionReport()),
    new TranRegistration.subtype(_GarbageCollectionStart, () => new _GarbageCollectionStart()),
    new TranRegistration.subtype(Shutdown, () => new Shutdown()),
    new TranRegistration.subtype(EndPointMessage, () => new EndPointMessage()),
    new TranRegistration.subtype(_ModelEvent, () => new _ModelEvent())
  ]);