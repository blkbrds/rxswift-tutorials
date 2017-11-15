[TOC]

## 1. Approach



### 1.1. Delegation

```swift
let dev = Developer()
// dev.leader = Leader()
dev.start() // How can developer refer leader for decision making? 
```

```swift
private protocol DeveloperDelegation {
    func me(_ me: Developer, shouldStart task: Task) -> YesNo
}
```

```swift
private class Leader: DeveloperDelegation {
    func me(_ me: Developer, shouldStart task: Task) -> YesNo {
        switch task {
        case .implement(_): return Yes
        case .report:       return Yes
        case .drinkBeer:    return No
        }
    }
}
```

```swift
private class Developer {
    var leader: DeveloperDelegation!
    var tasks: [Task] = [.implement(taskId: "123"), .implement(taskId: "456"), .report, .drinkBeer]
    
    func start() {
        for task in tasks {
            guard leader.me(self, shouldStart: task) else { continue }
            start(task)
        }
        stop()
    }
    
    func start(_ task: Task) { }
    
    func stop() { }
}
```



### 1.2. Callback

The delegation is clear enough.

But, sometime:

- There's only one case in definition
- The refer's process only, no referenced subject is needed

Callback (completion block) is created for this.

```swift
let dev = Developer()
dev.start(.implement(taskId: "123"), completion: { result in
    switch result {
    case .merged:
        dev.start(.drinkBeer, completion: nil)
    case .rejected:
        dev.start(.report, completion: nil)
    }
})
```



### 1.3. Functional

```swift
typealias Minutes = Double
struct Ride {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes
}
```

```swift
extension Array where Element == Ride {
    // imperative programming with insertion sort
    func _sortedNames() -> [String] {
        var names = [String]()
        for ride in self {
            names.append(ride.name)
        }
        for (i, name) in names.enumerated() {
            for j in stride(from: i, to: -1, by: -1) {
                if name.localizedCompare(names[j]) == .orderedAscending {
                    names.remove(at: i)
                    names.insert(name, at: j)
                }
            }
        }
        return names
    }

    // functional programming - what's order rule? that's all
    func sortedNames() -> [String] {
        return map { ride in ride.name }
            .sorted { s1, s2 in s1.localizedCompare(s2) == .orderedAscending }
    }
}
```



### 1.4. Promise

Promise - the golden path keeper & nested callback avoiding.

Implementation:

```swift
private class Developer {
    // via regular way
    func start(_ task: Task, completion: ((TaskResult) -> Void)?) {
        completion(.merged) // or
        completion(.rejected)
    }

    // via promise
    @discardableResult
    func start(_ task: Task) -> Promise<TaskResult> {
        return Promise { fulfill, reject in
            fulfill(.merged) // or
            reject(Issue.bug)
        }
    }
}
```

Usage:

```swift
let dev = Developer()
// via regular way
dev.start(.implement(taskId: "123"), completion: { result in
    switch result {
    case .merged:
        dev.start(.drinkBeer, completion: nil)
    case .rejected:
        dev.start(.report, completion: nil)
    }
})
// via promise
dev.start(.implement(taskId: "123"))
    .then { _ in dev.start(.drinkBeer) }
    .catch { _ in dev.start(.report) }
```



### 1.5. Reactive



## 2. Getting Started

### 2.1. Observable - starter

### 2.2. Observer - handler

### 2.3. Operator - man in the middle

## 3. Deep Dive

### 3.1. Creation

### 3.2. Operators

#### 3.2.1. Conditional

#### 3.2.2. Combination

This chapter will show you several different ways to assemble sequences, and how to combine the data within each sequence. Some operators you'll work with are similar to `Swift` collection operators.

**Prefixing and concatenating**:

- **``startWith()``**:

Emit a specified sequence of items before beginning to emit the items from the Observable.

Let's see the diagram below:

![start_width](./resources/images/3.2.2/start_width.png)

Implement and usage:

```swift
// 1
let numbers = Observable.of(2, 3)
// 2
let observable = numbers.startWith(1)
observable.subscribe(onNext: { value in
    print(value)
})
```

The startWith(_:) operator prefixes an observable sequence with the given initial value. This value must be of the same type as the observable elements.

Here’s what’s going on in the code above:

1. Create a sequence of numbers.
2. Create a sequence starting with the value 1, then continue with the original sequence of numbers.

Don’t get fooled by the position of the startWith(_:) operator! Although you chainit to the numbers sequence, the observable it creates emits the initial value,followed by the values from the numbers sequence.

Look at the debug area in the playground to confirm this:

```swift
1
2
3
```

​

* **``concat()``**:

  Emit the emissions from two or more Observables without interleaving them.

![concat](./resources/images/3.2.2/concat.png)

​

Usage:

```swift
// 1
let first = Observable.of(1, 1, 1)
let second = Observable.of(2, 2)
// 2
let observable = Observable.concat([first, second])
observable.subscribe(onNext: { value in
    print(value)
}) 
```

```swift
1
1
1
2
2
```

​

**Merging**: 

`merge`

Combine multiple Observables into one.

![merge](./resources/images/3.2.2/merge.png)

​

Usage:

```Swift
// 1
let left = PublishSubject<String>()
let right = PublishSubject<String>()
```

Now create a source observable of observable and create a merge observable:

```Swift
// 2
let source = Observable.of(left, right)
let observable = source.merge()
let disposable = observable.subscribe(onNext: { (value) in
    print(value)
})
```

Next, push some value for each observable:

```swift
// 3
print("> Sending a value to Left")
left.onNext("1")
print("> Sending a value to Right")
right.onNext("4")
print("> Sending another value to Right")
right.onNext("5")
print("> Sending another value to Left")
left.onNext("2")
print("> Sending another value to Right")
right.onNext("6")
print("> Sending another value to Left")
left.onNext("3")
```

One last bit before you're done.

```Swift
disposable.dispose()
```

Run code and see the result:

```Swift
> Sending a value to Left
1
> Sending a value to Right
4
> Sending another value to Right
5
> Sending another value to Left
2
> Sending another value to Right
6
> Sending another value to Left
3
```

Let's see the diagram below, following the code above:

![merge2](./resources/images/3.2.2/merge2.png)


* **Combining elements**:

  ![combine_last](./resources/images/3.2.2/combine_last.png)

  As diagram above, if we need to combine values from serveral sequences, RxSwift provides `combineLatest`operator to do it.

  Let's follow the code below:

  Setup two observables, it's used to push values then.

  ```swift
  // 1
  let first = PublishSubject<String>()
  let second = PublishSubject<String>()
  ```

  Next, create an observable that `combines` the latest values from both sequence (main idea of `combineLatest` section).

  ```Swift
  // 2
  let observable = Observable.combineLatest(first, second, resultSelector: { (lastFirst, lastSecond) in
  	print(lastFirst + " - " + lastSecond)
  })
  let disposable = observable.subscribe()
  ```

  Now, start to push values for each sequence:

  ```swift
  // 3
  print("> Sending a value to First")
  first.onNext("Hello,")
  print("> Sending a value to Second")
  second.onNext("world")
  print("> Sending another value to Second")
  second.onNext("RxSwift")
  print("> Sending another value to First")
  first.onNext("So easy to learn,")
  ```

  Finally, dispose our observable.

  ```swift
  disposable.dispose()
  ```

  Let's try it by yourself and see the result:

  ```swift
  > Sending a value to First
  > Sending a value to Second
  Hello, - world
  > Sending another value to Second
  Hello, - RxSwift
  > Sending another value to First
  Have a good day, - RxSwift
  ```

  ​

* **Triggers** (`withLatestFrom`):

  Similarly `combineLatest`, the function is called by`withLatestFrom` is being *trigger*.

  Why? Because we'll often need to accept data from serveral *observables* when another *observable* emits a event.

  Easier to understand, let's think about a `TextField` and a `Button`. We'll only be got the input from `TextField` until the `Button` is pressed.

  So, see the example below:

  ```swift
  // 1
  let button = PublishSubject<Any>()
  let textField = PublishSubject<String>()
  ```

  Now, create an observable with `withLatestFrom`, so when *button* emits a value, ignore it but instead emit the latest value received from the *textField*

  ```swift
  // 2
  let observable = button.withLatestFrom(textField)
  let disposable = observable.subscribe(onNext: { (value) in
      print(value)
  })
  ```

  Ok next, emit values for *button* and *textField* follow then and terminate the sequence:

  ```swift
  // 3
  textField.onNext("Rx")
  textField.onNext("RxSw")
  button.onNext("tap")
  textField.onNext("RxSwift")
  button.onNext("tap")
  button.onNext("tap")

  disposable.dispose()
  ```

  Let's see the result:

  ```swift
  RxSw
  RxSwift
  RxSwift
  ```

  No need diagram for above code??? That'll be fine...

  But look at here, with two observables *x* and *y*, same as *button* and *textField*. Just figure out by yourself.

  ![with_latest_from](./resources/images/3.2.2/with_latest_from.png)

  ​

* **Switches**:


  * `amb` - *ambiguous*:

    Or be known by `race`, given two or more source Observables, emit all of the items from only the first of these Observables to emit an event.

    ![amb](./resources/images/3.2.2/amb.png)

    You see, the second observable will be *chosen*. It means that the event will be emited by the second observable.

    Try the example below to understand:

    ```swift
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    // 1

    let observable = left.amb(right)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })

    // 2
    left.onNext("London")
    right.onNext("Copenhagen")
    left.onNext("Lisbon")
    left.onNext("Madrid")
    right.onNext("Vienna")
    right.onNext("Ha Noi")
    right.onNext("HCM")
    disposable.dispose()
    ```

    And the result:

    ```
    London
    Lisbon
    Madrid
    ```

    ​

  * `switchLatest`:

    Convert an Observable that emits Observables into a single Observable that emits the items emitted by the most-recently-emitted of those Observables.

    ![switch_latest](./resources/images/3.2.2/switch_latest.png)

    Following example below:

    ```swift
    // 1
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    let source = PublishSubject<Observable<String>>()

    // 2
    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })

    // 3
    source.onNext(one)
    one.onNext("Some text from sequence one")
    two.onNext("Some text from sequence two")
    source.onNext(two)
    two.onNext("More text from sequence two")
    one.onNext("and also from sequence one")
    source.onNext(three)
    two.onNext("Why don't you see me?")
    one.onNext("I'm alone, help me")
    three.onNext("Hey it's three. I win.")
    source.onNext(one)
    one.onNext("Nope. It's me, one!")

    disposable.dispose()
    ```

    ```
    Some text from sequence one
    More text from sequence two
    Hey it's three. I win.
    Nope. It's me, one!
    ```

    > Note: third section, when we switch to another observable, that will unsubscribe from the previously emitted observable.

* **Zip**:

  Such as `combineLatest`, but it combines the emissions of multiple Observables together via a specified function and emit single items for each combination based on the results of this function

  ![zip](./resources/images/3.2.2/zip.png)

  Now, let's see what’s going on in the code above:

  ```swift
  // 1
  let first = PublishSubject<String>()
  let second = PublishSubject<String>()

  // 2
  let observable = Observable.zip(first, second, resultSelector: { (lastFirst, lastSecond) in
      print(lastFirst + " - " + lastSecond)
  })
  let disposable = observable.subscribe()

  // 3
  print("> Sending a value to First")
  first.onNext("Hello,")
  print("> Sending a value to Second")
  second.onNext("world")
  print("> Sending another value to Second")
  second.onNext("RxSwift")
  print("> Sending another value to First")
  first.onNext("Have a good day,")

  disposable.dispose()
  ```

  > Note: compare with example of `combineLatest`, and figure out the difference.



#### 3.2.3. Filtering

#### 3.2.4. Mathematical

#### 3.2.5. Transformation

#### 3.2.6. Time Based

## 4. Testing

### 4.1. RxTest

### 4.2. RxNimble

https://academy.realm.io/posts/testing-functional-reactive-programming-code/

## 5. References



