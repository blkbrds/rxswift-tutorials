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

* **Prefixing and concatenating**:

  - **``startWith()``**:

  Emit a specified sequence of items before beginning to emit the items from the Observable.

  Let's see the diagram below:

  ![Screen Shot 2017-11-06 at 4.37.06 PM](/Users/ntschip/Desktop/Screen Shot 2017-11-06 at 4.37.06 PM.png)

  Implement and usage:

  ```swift
  example(of: "startWith") {
      // 1
      let numbers = Observable.of(2, 3)
    	// 2
    	let observable = numbers.startWith(1)
    	observable.subscribe(onNext: { value in
      	print(value)
    	})
  }
  ```

  The startWith(_:) operator prefixes an observable sequence with the given initial value. This value must be of the same type as the observable elements.

  Here’s what’s going on in the code above:

  1. Create a sequence of numbers.
  2. Create a sequence starting with the value 1, then continue with the original sequence of numbers.

  Don’t get fooled by the position of the startWith(_:) operator! Although you chainit to the numbers sequence, the observable it creates emits the initial value,followed by the values from the numbers sequence.

  Look at the debug area in the playground to confirm this:

  ```swift
  --- Example of: startWith ---
  1
  2
  3
  ```

  ​

  * **``concat()``**:

    Emit the emissions from two or more Observables without interleaving them.

  ![Screen Shot 2017-11-06 at 4.47.33 PM](/Users/ntschip/Desktop/Screen Shot 2017-11-06 at 4.47.33 PM.png)

  ​

  Usage:

  ```swift
  example(of: "Observable.concat") {
    	// 1
    	let first = Observable.of(1, 1, 1)
    	let second = Observable.of(2, 2)
  	// 2
    	let observable = Observable.concat([first, second])
    	observable.subscribe(onNext: { value in
      	print(value)
  	}) 
  }
  ```

  ```swift
  --- Example of: Observable.concat ---
  1
  1
  1
  2
  2
  ```

  ​

* **Merging**:

  Combine multiple Observables into one.

  ![Screen Shot 2017-11-06 at 5.03.01 PM](/Users/ntschip/Desktop/Screen Shot 2017-11-06 at 5.03.01 PM.png)

  ​

  Usage:

  ```Swift
  example(of: "merge") {
    	// 1
    	let left = PublishSubject<String>()
    	let right = PublishSubject<String>()
  ```

  Now create a source observable of observable:

  ```Swift
  	// 2
  	let source = Observable.of(left.asObservable(), right.asObservable())
  ```

  Next, create a merge observable:

  ```swift
  	// 3
  	let observable = source.merge()
  	let disposable = observable.subscribe(onNext: { value in
    		print(value)
  	})
  ```

  Then you need to randomly pick and push values to either observable. The loop uses up all values from `leftValues` and `rightValues` array then exist:

  ```swift
  	// 4
      var leftValues = ["Berlin", "Munich", "Frankfurt"]
      var rightValues = ["Madrid", "Barcelona", "Valencia"]
      repeat {
        	if arc4random_uniform(2) == 0 {
          	if !leftValues.isEmpty {
          	  	left.onNext("Left:  " + leftValues.removeFirst())
          	}
        	} else if !rightValues.isEmpty {
          	right.onNext("Right: " + rightValues.removeFirst())
        	}
      } while !leftValues.isEmpty || !rightValues.isEmpty
  ```

  One last bit before you're done.

  ```Swift
  	// 5
    	disposable.dispose()
  }
  ```

  Run code and see the result:

  ```Swift
  --- Example of: merge ---
  Right: Madrid
  Left:  Berlin
  Right: Barcelona
  Right: Valencia
  Left:  Munich
  Left:  Frankfürt
  ```

  Let's see the diagram below, following the code above:

  ![Screen Shot 2017-11-06 at 5.51.40 PM](/Users/ntschip/Desktop/Screen Shot 2017-11-06 at 5.51.40 PM.png)



* **Combining elements**:

  ![Screen Shot 2017-11-06 at 5.55.46 PM](/Users/ntschip/Desktop/Screen Shot 2017-11-06 at 5.55.46 PM.png)

  ​

* **Triggers**:

* **Switches**:

#### 3.2.3. Filtering

#### 3.2.4. Mathematical

#### 3.2.5. Transformation

#### 3.2.6. Time Based

## 4. Testing

### 4.1. RxTest

### 4.2. RxNimble

https://academy.realm.io/posts/testing-functional-reactive-programming-code/

## 5. References



