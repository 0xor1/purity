#Purity

Purity is both a coding pattern and a simple web framework for developing single
page, real time web apps with web sockets. Purity hides all of the server-client
communications from the developer and allows for the same app code to run
completely on the client for quick and rapid testing cycles, or with a few
additional lines of code, split the server side and client side ready for
production mode. Purity is currently in the early stages of development and so
only recommended for experimental use for now.

##Examples

* [Stopwatch](http://github.com/0xor1/purity_stopwatch_example)

##Pattern

The Pattern that Purity follows means you should split your application packages
into three distinct libraries, **Model**, **Interface** and **View**. The over
arching design of Purity is that each Model is independent and keeps its internal
state private, and notifies interested parties of internal state changes by emitting
events. These Events can be picked up by other models and views and used to update
other parts of the system and/or user interface. Other objects (views or models)
invoke changes on a models internal state by calling its pubic methods which
should always return void, because all communication of model state is done via 
asynchronous events.

###Model

The **Model** library is for pure application business logic and should
reference the **Purity** library `import 'package:purity/purity.dart';` and not
use any specific libraries that are only supported on either client (dart:html)
or server (dart:io). Each **Model** should `extend` off of the `class` **Model**
in the **Purity** library. When a models state changes it should `emitEvent` saying
so.

###Interface

The **Interface** library is the place to define abstract classes which explicitly define
each models public methods. Because models only reveal information about themselves
by emitting asynchronous events the method signatures defined on model interfaces
should always specify a return of `void`. The **Interface** library should also
contain the Events that your packages models will emit.

Once you have defined all of your model public methods and events, you then need
to register those types using the `registerTranType()` method from the
[transmittable](pub.dartlang.org/packages/transmittable) package, you don't need to
explicitly import transmittable, it is exported by the purity library.
It is best to register all your types in a single function call, to see how this is done,
look in [here](https://github.com/0xor1/transmittable/blob/dev/lib/src/registration.dart)
or [here](https://github.com/0xor1/purity_stopwatch_example/blob/dev/lib/interface/i_stopwatch.dart)

###View

The **View** library is where you define your visual elements that consume the
**interfaces** of your models by attaching event listeners to their underlying
models and making appropriate calls to their public methods. By having your views
only reference the interface library and not the model library, your business logic
will never leave the server and so always remain completely private from the user,
they will only ever have access to the public interface but not the implemenation.


##Run

Once you have setup a purity application you can run it either all on the client
for quick and rapid testing cycles, or you can split it and run it as a client-
server application. Taken from [Stopwatch](http://github.com/0xor1/purity_stopwatch_example)

`index.dart` For local testing
```dart
void main(){
  var model = new SW.Stopwatch();			//create the app model
  var view = new StopwatchView(model);		//create the app view
  document.body.children.add(view.html);	//drop the view on the page
}
```

`index.dart` For client-server app
```dart
void main(){
  initPurityAppView((stopwatch){			//initialise Purity
    var view = new StopwatchView(stopwatch);//create app view
    document.body.children.add(view.html);	//drop the view on the page
  });
}
```

`server.dart` for client-server app
```dart
void main(){
  var server = new PurityServer(			//create a purity server
      InternetAddress.LOOPBACK_IP_V4,
      4346,
      Platform.script.resolve('../build/web').toFilePath(),
      () => new SW.Stopwatch());			//create the app model
}
```
```