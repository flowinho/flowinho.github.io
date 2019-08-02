---
layout: post
title: "Higher-Order functions - functional programming in Swift 5"
tags: code
excerpt: "Starting in a new project is also way to encounter new or already known programming approaches in a clean way. To me, this happens currently with Functional Reactive Programming. I have to admit, my skills in FRP are very rusty. My source-code heavily relies on higher order functions and for the sake of testability i seek to implement pure functions as much as possible. Nevertheless, since i'm now required to hook into this topic even more, i need to freshen up my base understanding of functional programming."
---

Starting in a new project is also way to encounter new or already known programming approaches in a clean way. To me, this happens currently with **Functional Reactive Programming**. I have to admit, my skills in FRP are very rusty. My source-code heavily relies on higher order functions and for the sake of testability i seek to implement pure functions as much as possible. Nevertheless, since i'm now required to hook into this topic even more, i need to freshen up my base understanding of functional programming.

This article aims to explain the base fundamentals of functional programming Swift.

## Why pick up functional programming?

The base idea of functional programming is by not writing **imperative** code (*how things work*) but rather writing **declarative** code (*what should happen*), all by achiving software that features **immutable state**.

This introduces some major benefits:

- Easier testable. Since you write *pure functions* (we'll get into those later on) you can write small, concise and easily understandable unit-tests.
- The code is far more readable. A maintenance-engineer[^1] that took over your code will have an easier time reading and changing your code without breaking functionality.
- Since the approach aims for immutable state, that risk of side-effects is effectively zero. This means less bugs. 🐞

You see, functional programming brings some key benefits to software development. It's by far not a magical recipe for perfect code, but it enables you to write more readable, and easier to understand code.

> By itself, or in a simple system, mutable state is not necessarily a problem. Problems arise when connecting many objects together, such as in a large object-oriented system. Mutable state can produce headaches by making it hard to understand what value a variable has and how that value changes over time. -- [Warren Burton & Joe Howard](https://www.raywenderlich.com/9222-an-introduction-to-functional-programming-in-swift)

## Pure functions

Pure functions are one of the corner-stones of functional programming. A function can be considered **pure** if it satisfies the following two requirements:

- The function does not alter states outside of it. It causes zero side-effects.
- When given the same input, it will always produce the same output.

There are some great, pure higher-order functions[^2] inside `Foundation` already which i'd like to take a closer look at.

### Filter

`filter` is available on most `Collection`types. It iterates through all enumerated objects inside a collection and applies the functions it is given to all those objects, return either `true` when the passed functions returns true, or `false` respectively.
This indicates that **the function passed to filter has to return a boolean result in some way.**

Here is an example. Let's say you have five employees sitting inside an office:

```swift
struct Employee {
    let name: String
    let age: Int
}

let office = [Employee(name: "Thomas", age: 42), Employee(name: "Thorsten", age: 21), Employee(name: "Till", age: 50)]
```

Now we`d like to retrieve all employess that are older than 30, since those are our senior-developers 🤦🏻‍♂️ [^3]

We can achieve this by writing iterative code:

```swift
var result = [Employee]()
for employee in office {
    if employee.age > 30 {
        result.append(employee)
    }
}
```

Pretty straigt-forward. But also long. And ugly. Let's go for higher-order functions. There are two approaches to filter out our seniors, either by writing a function and pass it to filter, or by using Swift's closure-syntax.

Writing the function and passing it to filter:

```swift
func olderThanThirty(_ employee: Employee) -> Bool {
    return employee.age > 30
}
let seniorDevs = office.filter(olderThanThirty)
print(seniorDevs)
```

Advantages:

- The function `olderThanThirty` can be re-used on another place.
- The function `olderThanThiry` can be tested to ensure it's functionality.
- The term `office.filter(olderThanThirty` almost reads like a spoken command.

Alternatively, we can use a closure-syntax:

```swift
let seniors = office.filter({ $0.age > 30})
print(seniors)
```

Advantages:

- **Much** less code. 🕺🏻
- Since the filter function is not re-used, there will be no change in behaviour of other functions that use `olderThanThirty`.


### Map

`Map` returns an array of the same length as the Collection it is applied on and performs actions for all elements it iterates over. The returned type inside the array does not necessarily have to be same type as the base collection `map` is applied on. Let's say all of our previous employees use keyboards[^4] and we'd like to create a collection that holds them. Let's create a simple struct for this:

```swift
struct Keyboard {
    let owner: String
}
```

Now we use map to rapidly create an array of all the keyboards of our employees, with their respective owners assigend to it. Again we can do this by either writing the function and passing it to map, or using the closure-syntax.

Function:

```swift
func assignKeyboard(_ employee: Employee) -> Keyboard {
    return Keyboard(owner: employee.name)
}
let keyboards = office.map(assignKeyboard)
```

Closure:
```swift
let keyboards = office.map { Keyboard(owner: $0.name) }
```

And since senior-developers don't need a mouse, everyone is ready to work! ⌨️


### Reduce

Reduce is the swiss-knife higher-order function (SKHOF 🤪) in the repertoire of every iOS developer. Embrace it, it's imho one of the best pure functions that can be found in the Swift language. However, using it is not particularly straight-forward.

How does `reduce` work? I'll try to explain it in a very basic way: `reduce` takes two parameters.
The first can be of any type, and represents what can for the sake of easiness be called _the result_ of Reduce. The second one is the collection to iterate over.

In other words:

> Reduce iterates over the elements of a Collection and changes a given object of Type `T` for every iteration over this object.

Let's try a more practical example and create a list of all developers in the office. Again, we can do this by either writing a function or a closure:

Function:
```swift
typealias Developers = String
func assignDevelopers(_ list: Developers, employee: Employee) -> Developers {
    return list + " 💻 \(employee.name)"
}
let developerList = office.reduce("Developers in the office:", assignDevelopers)
print(developerList)

// Output: Developers in the office: 💻 Thomas 💻 Thorsten 💻 Till
```

Closure:
```swift
typealias Developers = String
let list = office.reduce("Developers in the office:") { list, employee in list + " 💻 \(employee.name)"}
print(list)

// Output: Developers in the office: 💻 Thomas 💻 Thorsten 💻 Till
```

How do both of these functionalities work? `reduce` takes the initial value `"Developers in the office:"` and iterates over every `Employee` in `office`. I'll try to paint the picture:

1. Value of `list` -> `"Developers in the office:"`
1. First iteration, Value of `list` -> `"Developers in the office: 💻 Thomas"`
1. Second iteration, Value of `list` -> `"Developers in the office: 💻 Thomas  💻 Thorsten"`
1. Third iteration, Value of `list` -> `"Developers in the office: 💻 Thomas 💻 Thorsten 💻 Till"`

To add the name of the employee to the result, `reduce` needs a reference to it, hence the `list` object is stated in the function signature, respectively the closure signature.

## Conclusion

Functional programming is a good way to write stable, high quality and precise code, that is easy to read, and well to maintain. If you aren't familiar with it by now, i'd like to encourage you into having a look. 

It's lots of fun, and way of programming that just feels _right_.

---

**Footnotes:**

[^1]: Which might as well be yourself.
[^2]: In Swift, functions are first-class citizens. This means they can be referenced and tossed-around as much as any other object or value. Functions that take other functions as parameters are called *higher-order functions*.
[^3]: Just a joke. There's a common misunderstanding that senior-developers are experienced as in _years worked_. That's totally imcomprehensable to me since a programmer can be bad for years. Working for a set amount of years is not an applicable measurement of the skills of a developer.
[^4]: Wireless Mac Keyboards 🤭