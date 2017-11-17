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

#### 3.2.3. Filtering

#### 3.2.4. Mathematical

#### 3.2.5. Transformation

#### 3.2.6. Time Based

- **Replay**

Lấy lại được nhiều event của sequence.

![replay-diagram](./resources/images/3.2.6/replay-diagram.png)

```swift
let replayedElements = 3
// 1
let replaySubject = ReplaySubject<Int>.create(bufferSize: replayedElements)

_ = replaySubject.subscribe({
	print($0)
})
// 2
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
	if let e = $0.element {
		replaySubject.onNext(e)
	}
})
// 3
DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
	replaySubject.subscribe({
		print("replay:", $0)
	}).dispose()
}
```

Giải thích:

1. Tạo 1 ReplaySubject với `bufferSize = 3  `
2. Cứ mỗi giây phát ra một event.
3. Phát lại sau 5s 

- **Buffer**

The Buffer operator transforms an Observable that emits items into an Observable that emits buffered collections of those items.

![buffer-diagram](./resources/images/3.2.6/buffer-diagram.png)

```swift
let bufferTimeSpan: RxTimeInterval = 3
let bufferMaxCount = 5
let publicSubject = PublishSubject<Int>()
// 1
_ = publicSubject.buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
	print($0)
})
// 2
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
	if let e = $0.element {
		publicSubject.onNext(e)
	}
})
```

Giải thích:

1. Đăng ký observable có buffer với `timeSpan = 3`  và `count = 5 `
2. Cứ mỗi giây phát ra một event.

- **Window**

Tách observable từ observable sau 1 khoảng thời gian (timespan) và số lượng event cho phép tối đa (count).

![window-diagram](./resources/images/3.2.6/window-diagram.png)

```swift
let bufferTimeSpan: RxTimeInterval = 3
let bufferMaxCount = 5
let publicSubject = PublishSubject<Int>()
// 1
_ = publicSubject.window(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
	print($0)
})
// 2
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
	if let e = $0.element {
		publicSubject.onNext(e)
	}
})
```

Giải thích:

1. Đăng ký observable có timeout với `timeSpan = 3`  và `count = 5 `
2. Cứ mỗi giây phát ra một event.

- **Delay**

Observable được phát ra sau 1 khoảng delay.

![delay-diagram](./resources/images/3.2.6/delay-diagram.png)

```swift
let delayInSeconds: RxTimeInterval = 3
let publicSubject = PublishSubject<Int>()
// 1
_ = publicSubject.delay(delayInSeconds, scheduler: MainScheduler.instance).subscribe({
	print($0)
})

_ = publicSubject.subscribe({
	print($0)
})
// 2
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
	if let e = $0.element {
    	publicSubject.onNext(e)
	}
})
```

Giải thích:

1. Đăng ký observable có delay với ```delayInSeconds = 3```. Có nghĩa là sau khoảng 3s kể từ khi observable phát ra event thì observer sẽ nhận được event. 
2. Cứ mỗi giây phát ra một event.

- **Timeout**

Cho 1 khoảng thời gian Timeout, nếu trong khoảng timeout đó không có event nào được phát ra thì sẽ ngắt observable và trả về Error.

![timeout-diagram](./resources/images/3.2.6/timeout-diagram.png)

```swift
let dueTime: RxTimeInterval = 3
let publicSubject = PublishSubject<Int>()
// 1
_ = publicSubject.timeout(dueTime, scheduler: MainScheduler.instance)
	.subscribe(onNext: {
		print($0)
	}, onError: {
      	// 2
		print("error")
		print($0)
	})
// 3
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
	if let e = $0.element, e <= 10 {
		publicSubject.onNext(e)
	}
})
```

Giải thích:

1. Đăng ký observable có timeout với ```dueTime = 3```.
2. Trả về Error nếu event lỗi hoặc trong khoảng timeout không có event nào được phát ra.
3. Cứ mỗi giây phát ra một event.

## 4. Testing

### 4.1. RxTest

### 4.2. RxNimble

https://academy.realm.io/posts/testing-functional-reactive-programming-code/

## 5. References



