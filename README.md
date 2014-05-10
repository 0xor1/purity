#Purity [![Build Status](https://drone.io/github.com/0xor1/purity/status.png)](https://drone.io/github.com/0xor1/purity/latest)

Purity is a framework for building applications following a **Source->Consumer** pattern.
A **Source** is an object which emits **Events**, a **Consumer** is an object which listens
for **Events** from a single **Source**. A **Consumer** may consume a **Source** directly,
or it may consume it by proxy over a **Stream<String>**. Any infrastructure which supports
**Stream<String>** will support the Purity framework, for example, it will work directly
in memory, or over a **HTTP** connection.

Learning to use Purity is best done by following examples:

##Examples

* Stopwatch
    * [Repo](http://github.com/0xor1/purity_stopwatch_example)
    * [Local test with Purity](http://0xor1.net/purity_stopwatch_example/index_with_purity.html)
    * [Local test without Purity](http://0xor1.net/purity_stopwatch_example/index_without_purity.html)