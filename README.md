#Purity [![Build Status](https://drone.io/github.com/0xor1/purity/status.png)](https://drone.io/github.com/0xor1/purity/latest)

Purity is a web framework and coding pattern designed to make building complex 
realtime web apps as simple and pain free as possible. It encourages the 
development of code that promotes code reuse, unit testing and rapid manual 
testing cycles with minimal system setup required to test code changes quickly.

The Purity core server has two thin wrappers allowing it to be run in production
mode in the standalone Dart VM as a real application server, or to be run in a 
web page and serve the client side portions of the app to the same page, 
enabling the functionality across the entire application stack to be tested and 
debugged in a single web page.

The Purity coding pattern enables developers to focus on writing the meaningful
parts of an application, namely the Models and the Views. The Purity framework
takes care of routing all communications between Models on the server and Views
on the client so developers don't need to write any Controllers for handling 
such communications.

##Principles Of Purity

In a Purity web app the **Server** is called the **Host** because its primary
role isn't to serve web pages but to actually host running instances of the
application itself. A **Model** is called a **Source** because it is a source of
**Events** by which it broadcasts information about its internal state changes. 
A **View** is called a **Consumer** because it consumes a **Source** by 
listening for its **Events** and updates itself accordingly.

In order for Purity to work each client is connected to its server side session
via a single persistant **WebSocket**. When a **Source** emits an **Event**, if 
there are any **Consumers** on the client side consuming that **Source**, the 
Purity framework will intercept the **Event** and propogate it down to the 
client side so the interested **Consumers** can be updated with the latest 
changes within the application. 

A **Consumer** can make calls to its **Source** as though it was in the same 
environment, this is made possible by **noSuchMethod**. When the application is 
running within the Purity framework it will strip out all **Source** objects 
from **Events** that it propogates down to the client side and replace them with
**_Proxy** objects. A **_Proxy** object detects method calls that are made on it
by implementing **noSuchMethod** and passes them back to the server side where
the real **Source** will have that particular method call invoked on it. For 
this reason **Source** objects should not specify public methods with return 
values other than void. This is so when a **Consumer** on the client side makes 
a method call to a **Source** it doesn't lock up the client side waiting for a 
direct return value from the method call.

The principles of how Purity works are nicely illustrated in the simple 
**Stopwatch** example application (links below). The "Local test with Purity"
demonstrates the host running in a web page, serving instances of the client 
side end-points to the same page. the strings that appear in the host view are 
the communications that you would see in the browser network tab if it was 
running in full production mode. The "Local test without Purity" shows that the 
design of a Purity application even enables it to be run without the Purity host
there at all, and instead simply have the **Consumers** consume their 
**Sources** directly.

* Stopwatch
    * [Repo](http://github.com/0xor1/purity_stopwatch_example)
    * [Local test with Purity](http://0xor1.net/purity_stopwatch_example/index_with_purity.html)
    * [Local test without Purity](http://0xor1.net/purity_stopwatch_example/index_without_purity.html)

