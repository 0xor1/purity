#Purity [![Build Status](https://drone.io/github.com/0xor1/purity/status.png)](https://drone.io/github.com/0xor1/purity/latest)

Purity is a web framework designed to make building complex 
realtime web apps as simple and pain free as possible. It encourages the 
development of code that promotes code reuse, unit testing and rapid manual 
testing cycles with minimal system setup required to test code changes quickly.
Purity apps are written in Dart which enables the same code to be shared 
between client side and server side.

The Purity core server has two thin wrappers allowing it to be run in production
mode in the standalone Dart VM as a real application server, or to be run in a 
web page and serve the client side portions of the app to the same page, 
enabling the functionality across the entire application stack to be tested and 
debugged in a single web page.

Purity enables developers to focus on writing the meaningful
parts of an application, namely the Models and the Views. The Purity framework
takes care of routing all communications between Models on the server and Views
on the client so developers don't need to write any Controllers for handling 
such communications.

##Examples

* Stopwatch
    * [Repo](http://github.com/0xor1/purity_stopwatch_example)
    * [Local test with Purity](http://0xor1.github.io/purity_stopwatch_example/)
    * [Local test without Purity](http://0xor1.github.io/purity_stopwatch_example/without_purity/)

* Chat
    * [Repo](http://github.com/0xor1/purity_chat_example)
    * [Local test with Purity](http://0xor1.github.io/purity_chat_example/)
    * [Local test without Purity](http://0xor1.github.io/purity_chat_example/without_purity/)