#Purity

Purity is a web framework designed to make web app development faster, easier,
more maintainable and more testable than ever before. It removes the need for 
developers to write any client-server communications code, that means no http
requests on the client and no http request handlers on the server. The pattern 
Purity employs keeps your data, business logic and view entities seperated
and independent which means business logic should be easy to unit test and
your Purity projects should be easy to maintain, extend and reuse.

The Purity pattern also allows you to run your applications fully just on the client
side for fast and frequent testing cycles, this can be done without using the Purity
framework for a very simple test setup and simple app debugging. However, one nice
feature of Purity is that the core application server itself can be run on the client
side, meaning you can fully test your application with the purity framework all 
on a single web page with useful views already provided to make debugging Purity
apps as easy as pie, all of this works both in native Dart and compiled javascript.

##Examples

* [Stopwatch](http://github.com/0xor1/purity_stopwatch_example)

To use the Purity framework all you have to do is follow the golden rules:

##The Golden Rules (quick glance)

  1. Business Logic Entities (Models), extend from PurityModel and emit PurityEvents when their internal state changes
  2. View Entities (Views) extend from PurityModelConsumer (or PurityView for more built in html support) and attach event listeners to the models they represent 
  3. Data Entities (Data) are well defined and are registered as Transmittable types
  4. The interfaces which Models expose to Views are explicitly declared in abstract classes and contain only methods which all return void
  5. All of the types used as arguments to the Model interfaces, the Data Entities and the event tpes are all registered as Transmittable types
  6. A View may only consume and represent one Model, though a Model may be consumed and represented by any numver of Views
  
##The Golden Rules (in depth)

Purity Application packages are split into three distinct
libraries, **Interface**, **Model** and **View**. 

###Interface

The Interface library should reference the Purity library and declare all the
model interfaces as abstract classes containing only methods which all return void.
The interface library should also declare all of the data entity types which extend
Transmittable and event types which extend PurityEvent. Perhaps most importantly to note,
is the interface library should contain a top level function used to register 
all of the data entity types, all the types used as arguments to the model interface
methods and all the event types as Transmittable types.

  * From the [Stopwatch]() example
  ```dart
  library IStopwatch;
  import 'package:purity/purity.dart';
  
  class DurationChangeEvent extends PurityEvent implements IDurationChangeEvent{}
  abstract class IDurationChangeEvent{
    Duration duration;
  }

  class StartEvent extends PurityEvent{}

  class StopEvent extends PurityEvent{}
  
  abstract class IStopwatch{
    void start();
    void stop();
    void reset();
  }

  bool _stopwatchTranTypesRegistered = false;
  void registerStopwatchTranTypes(){
    if(_stopwatchTranTypesRegistered){ return; }
    _stopwatchTranTypesRegistered = true;
    registerTranTypes('Stopwatch', 's', (){
      registerTranSubtype('a', DurationChangeEvent);
      registerTranSubtype('b', StartEvent);
      registerTranSubtype('c', StopEvent);
    });
  }
  ```

###Model

The Model library should reference Purity and associated interface library, it
should only be concerned with business logic, it should not reference dart:io / 
dart:html or any other client-server only libraries. This keeps your app logic
seperated from data persistance and view concerns and makes it simple to unit test.

  * From the [Stopwatch]() example, note that the constructor calls the interface
    libraries registerStopwatchTranTypes() function. and emits events when appropriate.
  ```dart
  library Stopwatch;
  import 'package:purity/purity.dart';
  import 'package:stopwatch/interface/i_stopwatch.dart';
  
  class Stopwatch extends PurityModel implements IStopwatch{
    
    Stopwatch(){
      registerStopwatchTranTypes();
    }
    
    void start(){
      //do start logic
      emitEvent(new StartEvent()); //tell anyone listening my state has changed
    }

    void stop(){
      //do stop logic
      emitEvent(new StopEvent()); //tell anyone listening my state has changed
    }

    void reset(){
      //do reset stuff
    }
    
    Duration _duration;
    void _setDuration(Duration duration){
      //do some private setDuration logic
      emitEvent(new DurationChangeEvent()..duration = _duration);
    }
    
  }
  ``` 

###View

The **View** library should reference PurityClient if it is implementing views for the client side,
is where you define your visual elements that consume the **interfaces** 
of your models by attaching event listeners to their underlying models and making
appropriate calls to their public methods. By having your views only reference 
the interface library and not the model library, your business logic will never 
leave the server and so always remain completely private from the user, they will
only ever have access to the public interface but not the implemenation.

  * From the [Stopwatch]() example, again notice that the view constructor calls
    the interface top level method to register the transmittable types.
  ```dart
  library StopwatchView;
  import 'package:purity/purity_client.dart';
  import 'package:purity_stopwatch_example/interface/i_stopwatch.dart';

  class StopwatchView extends PurityView{

    IStopwatch get stopwatch => model;

    StopwatchView(stopwatch):
      super(stopwatch){

      registerStopwatchTranTypes();

      //do html initialisation stuff

      _startButton.onClick.listen((e) => stopwatch.start());
      _stopButton.onClick.listen((e) => stopwatch.stop());

      listen(stopwatch, DurationChangeEvent, (dce){/*handle event*/});

      stopwatch.reset();

    }

  }
  ```
  
##Run Configurations

Once you have setup a purity application you can run it either all on the client
for quick and rapid testing cycles, or you can split it and run it as a client-
server application. Taken from [Stopwatch](http://github.com/0xor1/purity_stopwatch_example)

`index.dart` for local testing without Purity
```dart
void main(){
  var model = new SW.Stopwatch();     //create the app model
  var view = new StopwatchView(model);    //create the app view
  document.body.children.add(view.html);  //drop the view on the page
}
```

`index.dart` for local testing with Purity
```dart
void main(){

  new PurityTestServer(
    ()=> new Stopwatch(),
    (stopwatch){/*no closing code required here*/});
  var model = new SW.Stopwatch();     //create the app model
  var view = new StopwatchView(model);    //create the app view
  document.body.children.add(view.html);  //drop the view on the page
}
```

`index.dart` for client-server app
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
      () => new SW.Stopwatch(),       //create the app model
      (stopwatch){});                 //close the app (nothing needs doing in this instance)			
}
```
```