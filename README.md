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

Sau khi đã khởi tạo **Observable**, thì subcribes **Observable** để nhận các sự kiện (events). Và ở đây, **Observer** dùng để nhận sự kiện mỗi khi có sự kiện phát ra.

**Observers** có thể nhận 3 kiểu sự kiện:

- **next**: Observable có thể có không hoặc nhiều elements nên sẽ có không hoặc nhiều `next` events được gửi tới **Observer** và đây là nơi để **Observer** nhận dữ liệu từ Observable.
- **completed**: nhận sự kiện này khi Observable hoàn thành life-cycle của nó, và không còn phát ra bất kỳ events nào nữa (không vào sự kiện **next** nữa)
- **error**: nhận sự kiện này khi Observable kết thúc với một error và tương tự như *completed*, **Observer** không nhận một sự kiện `next` nào nữa.

Sau khi phát sự kiện *completed* và *error*, thì các dữ liệu của **Observable** sẽ được giải phóng

**return** hàm `subscribe(_ observer: O)`  là **Disposable** dùng để cancel Observable và giải phóng bộ nhớ

**Example**

```swift
let obj = Observable.from(["🐶", "🐱", "🐭", "🐹"]) // Khởi tạo một Observable
obj.subscribe( // Thực hiện subscribe Observable
  onNext: { data in
    print(data) // Nơi nhận dữ liệu của Observer được gửi đi từ Observable
  }, 
  onError: { error in
    print(error) // Nơi nhận error và Observable được giải phóng
  }, 
  onCompleted: {
    print("Completed") // Nhận được sự kiện khi Observable hoàn thành life-cycle và Observable được giải phóng
  })
   .disposed()
```

```swift
🐶
🐱
🐭
🐹
Completed
```

**iOS**

```swift
@IBOutlet weak var textField: UITextField!

override func viewDidLoad() {
  super.viewDidLoad()
  let observable = textField.rx.text.orEmpty // Khởi tạo observable
  observable.subscribe(onNext: { (text) in 
  // Mỗi lần thay đổi text trong textField, Observer sẽ nhận được giá trị text mới của textField.
    print(text)
  })
}
```



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

- **Timeout**

Cho 1 khoảng thời gian Timeout. Sau khi subscribe, trong vòng 3s mà không có event nào phát đi kể từ lần cuối phát event hay subscribe thì sẽ trả về Timeout Error và ngắt Observable.

![timeout-diagram](./resources/images/3.2.6/timeout-diagram.png)

```swift
let dueTime: RxTimeInterval = 3
// Khởi tạo 1 PublishSubject.
let publicSubject = PublishSubject<Int>()

// Áp dụng timeout vào publishSubject, sau khi subscribe nếu trong vòng 3s mà không có event nào phát đi kể từ lần cuối phát event hay subscribe thì sẽ trả về timeout error và ngắt observable.
_ = publicSubject.timeout(dueTime, scheduler: MainScheduler.instance)
	.subscribe(onNext: {
		print("Element: ", $0)
	}, onError: {
		print("Timeout Error")
		print($0)
	})

// Khởi tạo 1 observable timer interval, timer này có nhiệm vụ cứ mỗi giây phát ra 1 event.
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
  	// Nếu event nhận được từ timer có element <=5 thì publishSubject sẽ phát đi event.
	if let e = $0.element, e <= 5 {
		publicSubject.onNext(e)
	}
})
```

```swift
// Output: Mỗi giây publishSubject phát ra 1 event.
element:  0
element:  1
element:  2
element:  3
element:  4
element:  5
// Đoạn này element >5 nên không phát gì được nữa. Cùng nhìn xem sau 3s ra cái gì nhé!
Timout error
Sequence timeout.
```



- **Delay**

Observable được phát ra sau 1 khoảng delay.

![delay-diagram](./resources/images/3.2.6/delay-diagram.png)

```swift
let delayInSeconds: RxTimeInterval = 3
// Khởi tạo 1 PublicSubject
let publicSubject = PublishSubject<Int>()

// Áp dụng delay vào publishSubject với dueTime = 3. Nghĩa là sau khi subscribe, nếu publishSubject phát ra event thì sau 3s subsribe mới nhận được event.
_ = publicSubject.delay(delayInSeconds, scheduler: MainScheduler.instance).subscribe({
	print($0)
})

publicSubject.onNext("Sau 3s mới nhận được nhé!")
```

```swift
// Output: Chờ 3s và nhận kết quả nhé.
next(Sau 3s mới nhận được nhé!)
```



- **Window**

Tách observable từ observable sau 1 khoảng thời gian (timespan) và số lượng event cho phép tối đa (count).

![window-diagram](./resources/images/3.2.6/window-diagram.png)

```swift
let bufferTimeSpan: RxTimeInterval = 3
let bufferMaxCount = 2
// Khởi tạo 1 PublicSubject
let publicSubject = PublishSubject<Int>()

// Áp dụng window vào publishSubject với bufferTimeSpan = 3 và bufferMaxCount = 2. Nghĩa là sau mỗi 3s sẽ tách ra 1 observable con chứa những event được phát ra trong khoảng 3s đó từ observable mẹ (Tối đa là 2 event).
_ = publicSubject.window(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
	if let element = $0.element {
		print("New Observable")
		_ = element.subscribe({
			print($0)
		})
	}
})

// Khởi tạo 1 observable timer interval, timer này có nhiệm vụ cứ mỗi giây phát ra 1 event.
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
  	// Nếu event nhận được từ timer có element < 6 thì publishSubject sẽ phát đi event.
	if let e = $0.element, e < 6 {
		publicSubject.onNext(e)
	}
})
```

```swift
// Output: Trong 6s sẽ tạo ra được 3 observable mới.
New Observable
next(0)
next(1)
completed

New Observable
next(2)
next(3)
completed

New Observable
next(4)
next(5)
completed
```



- **Replay**

Sau khi subscribe sẽ lấy lại được nhiều event trước đó.

![replay-diagram](./resources/images/3.2.6/replay-diagram.png)

```swift
let replayedElements = 3
// Khởi tạo 1 PublicSubject
let publicSubject = PublishSubject<Int>()

// Áp dụng replay vào publishSubject với replayedElements = 3. Nghĩa là sau khi subscribe sẽ nhận lại được tối đa 3 event trước đó nếu có.
let replayObservable = publicSubject.replay(replayedElements)
_ = replayObservable.connect()

// publicSubject phát đi 5 events.
for i in 0...4 {
	publicSubject.onNext(i)
}

_ = replayObservable.subscribe({
	print("replay: ", $0)
})
```

```swift
// Output:
next(0)
next(1)
next(2)
next(3)
next(4)
replay:  next(2)
replay:  next(3)
replay:  next(4)
```



- **Buffer**

Biến đổi `observable<Type> ` thành `observable<[Type]>` .

![buffer-diagram](./resources/images/3.2.6/buffer-diagram.png)

```swift
let bufferTimeSpan: RxTimeInterval = 3
let bufferMaxCount = 3
// Khởi tạo 1 PublicSubject
let publicSubject = PublishSubject<Int>()

// Áp dụng buffer vào publishSubject với timeSpan = 3 và count = 3. Nghĩa là sau khi subscribe sẽ nhận được tập hợp những event được phát đi trong khoảng 3 giây và tối đa là 3 event.
_ = publicSubject.buffer(timeSpan: bufferTimeSpan, count: bufferMaxCount, scheduler: MainScheduler.instance).subscribe({
	print($0)
})

// Khởi tạo 1 observable timer interval, timer này có nhiệm vụ cứ mỗi giây phát ra 1 event.
let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
_ = timer.subscribe({
  	// Nếu event nhận được từ timer có element < 6 thì publishSubject sẽ phát đi event.
	if let e = $0.element, e < 6 {
		publicSubject.onNext(e)
	}
})
```

```swift
// Output:
Event nhận được sau khi buffer:  next([0, 1, 2])
Event nhận được sau khi buffer:  next([3, 4, 5])
```



## 4. Testing

### 4.1. RxTest

### 4.2. RxNimble

https://academy.realm.io/posts/testing-functional-reactive-programming-code/

## 5. References



