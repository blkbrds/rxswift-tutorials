**Reactive Programming with Swift**

> Mọi chia sẻ hay sao chép phải được cấp phép, tác quyền thuộc team iOS - Asian Tech, Inc

# Contents
1. [Approach](#Approach)
	1. [Delegation](#Delegation)
	2. [Callback](#Callback)
	3. [Functional](#Functional)
	4. [Promise](#Promise)
	5. [Reactive](#Reactive)

2. [Get Started](#get-started)
	1. [Observable - starter](#Observable-starter)
	2. [Observer - handler](#Observer-handler)
	3. [Operator - man in the middle](#Operator-man-in-the-middle)
	4. [Subjects](#Subjects)

3. [Deep Dive](docs/Deep-dive)
	1. [Creation](docs/Deep-dive/Creation.md)
	2. [Operators](docs/Deep-dive/Operators)
	3. [MVVM](docs/Deep-dive/MVVM.md)

4. Intermediate(Update later)

5. [Testing](docs/Testing.md)
	1. [RxTest](#RxTest)
	2. [RxNimble](#RxNimble)
6. [References](#References)

## 1. Approach <a name="Approach"></a>
### 1.1. Delegation <a name="Delegation"></a>

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

### 1.2. Callback <a name="Callback"></a>
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

### 1.3. Functional <a name="Functional"></a>

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

### 1.4. Promise <a name="Promise"></a>

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

### 1.5. Reactive <a name="Reactive"></a>

**Reactive programming là gì?**

 **Reactive programming is programming with asynchronous data streams.**

*Reactive programming* là lập trình xử lý các luồng dữ liệu bất đồng bộ hay những thay đổi có tính lan truyền (the propagation of change). Khái niệm luồng (stream) phổ biến, bạn có thể tạo luồng dữ liệu (data streams) từ bất cứ thứ gì (anything can be a stream): các biến (variables), giá trị đầu vào từ người dùng (user inputs), properties, caches, data structures, etc.

Streams là trung tâm của `reactive`, mô hình dưới đây là luồng sự kiện "click vào 1 button"

![reactive](./resources/images/1.5/reactive.png)

Một luồng là một dãy (sequence) các sự kiện đang diễn ra được sắp xếp theo thời gian. Nó có thể phát ra 3 thứ: một giá trị, một error, hoặc một `completed`. Ở đây tín hiệu giúp ta biết được khi nào luồng sự kiện click `completed` là khi window hoặc view chứa button bị đóng lại.

Chúng ta bắt các sự kiện **bất đồng bộ** bằng cách define một function execute khi một giá trị được phát ra, một function khác khi error được phát ra, tương tự với `completed`. Các function chúng ta define là các observer, luồng(stream) là chủ thể đang được lắng nghe(being observed) hay còn gọi là observable.

Xem sét sơ đồ được vẽ bằng ASCII sau:

```groovy
--a---b-c---d---X---|->

a, b, c, d là các giá trị được phát ra
X là một error nào đó
| là một signal 'completed'
----> is the timeline
```

## 2. Getting Started <a name="get-started"></a>

### 2.1. Observable - starter <a name="Observable-starter"></a>

> Khái niệm observable đến từ observer design pattern là một đối tượng thông báo cho các đối tượng theo dõi về một điều gì đó đang diễn ra. [source](https://xgrommx.github.io/rx-book/content/observable/index.html#)

- Diagrams dưới đây đại diện cho  `Observables` và quá trình biến đổi của `Observables`:

![Observable-diagram](./resources/images/2.1/Observable-diagram.png)

- Trong [ReactiveX](http://reactivex.io/documentation/observable.html), một `Observer` đăng ký một `Observable` sau đó `Observer` sẽ phản ứng lại bất cứ item hay chuỗi các item mà `Observable` phát ra. Phần này sẽ giải thích cụ thể reactive parttern là gì.

#### 2.1.1 Mở đầu

- Có nhiều rất nhiều thuật ngữ dùng để mô tả mô hình và thiết kế của lập trình bất đồng bộ. Trong tài liệu này sẽ thống nhất sử dụng những thuật ngữ sau: 
  - Một `Observer` đăng ký với `Observable`.
  -  Một `Observable` phát ra các items hoặc gửi các notifications đến các `Observers` bằng cách gọi các `Observers` methods.

#### 2.1.2 Khởi tạo `Observers`

- Trong mô hình bất đồng bộ, flow sẽ giống như sau:

  1. Khai báo một method có giá trị được trả về từ một hàm gọi bất đồng bộ; method này là một phần của `*observer*`.
  2. Khai báo một `*Observable*`, 
  3. Gán `observer` vào `Observable` bằng cách đăng kí nó (*subscribing* it) .
  4. Xử lý các business logic bất cứ khi nào cuộc gọi trả về(whenever the call returns), method của `observer`  sẽ bắt đầu xử lý trên dựa trên giá trị trả về hoặc các giá trị (items) được phát ra bởi `Observerble`.

  ```groovy
  // Khai báo, nhưng không gọi, handler onNext của Subscriber
  // Trong ví dụ này, observer rất đơn giản và chỉ có onNext handler
  def myOnNext = { it -> do sth usefull with it }
  // defines, nhưng ko gọi, Observable
  def myObservable = someObservable(itsParameters);
  // Đăng ký Subscriber(myOnNext) Observable(myObservable), và invokes Observable
  myObservable.subscribe(myOnNext);
  // go on about my business
  ```

- **onNext, onCompleted, và onErrror**

  ​	[The `Subscribe` method](http://reactivex.io/documentation/operators/subscribe.html) là cách bạn kết nối `observer` với `Observable`. observer implement của bạn là tập hợp các methods dưới đây:

  `onNext`: `Observable` gọi hàm này bất cứ khi nào `Observable` phát đi item. Hàm này có tham số là item được phát ra bởi `Observable`.

  `onError`: `Observable` gọi hàm này để biểu thị có lỗi phát sinh trong khi xử lý dữ liệu hoặc có một số lỗi khá. Nó sẽ không gọi thêm đến các hàm `onNext` hoặc `onCompleted`. 

  `onCompleted`: `Observable` gọi hàm này sau khi hàm `onNext` cuối cùng được gọi, nếu không có bất kì lỗi nào xảy ra.

  A more complete `subscribe` call example looks like this:

  ```groovy
  def myOnNext = { item -> /* do something useful with item */ };
  def myError = { throwable -> /* react sensibly to a failed call */ };
  def myComplete = { /* clean up after the final response */ };
  def myObservable = someMethod(itsParameters);
  myObservable.subscribe(myOnNext, myError, myComplete);
  // go on about my business
  ```

- **"Hot" và "Cold" Observable**

  Khi nào `observable` phát ra chuỗi các `items`? Điều đó phụ thuộc vào `Observable`. Một "hot" Observable có thể bắt đầu phát các items ngay khi nó được tạo ra, và sau đó bất kỳ `Observer` nào đăng ký tới `observable` đều có thể bắt đầu quan sát (observing) từ khoản giữa của tiến trình . Trái lại, "Cold" observable thì chờ cho đến khi một `observer` nào đó đăng kí vào `observable` trước khi nó bắt đầu phát ra các items, và do đó `observer` có thể đảm bảo được việc quan sát từ toàn bộ các tiến trình từ lúc bắt đầu ( to see the whole sequence from the beginning.)

  [Read more](http://reactivex.io/documentation/observable.html)

### 2.2. Observer - handler <a name="Observer-handler"></a>

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



### 2.3. Operator - man in the middle <a name="Operator-man-in-the-middle"></a>
Operators là những phép toán cho phép biển đổi observable thành observable mới để phù hợp với nhu cầu sử dụng

Một số operators cơ bản trong RxSwift được liệt kê tại mục 3.2

**Example 1:**

![Filter](./resources/images/2.3/2.3.png)

```swift
let observable = Observable.of(2,30,22,5,60,1) // 1
let newObservable = observable.filter { $0 > 10 } // 2
```
**OUTPUT: 30 22 60**

1. Khởi tạo observable các số nguyên --2--30--22--5--60--1
2. Qua phép filter với điều kiện ($0 > 10). Chúng ta đã có được một observable mới là --30--22--60


**Example 2:**
	Ở ví dụ này chúng ta sử dụng phép filter vào việc tìm kiếm bằng UISearchBar control

```swift	
let observable = searchBar.rx.text.orEmpty.asObservable() // 1   

observable.filter { $0.hasPrefix("Number") } // 2
.subscribe(onNext: { (text) in // 3
	// Do something when emit events
})
.disposed(by: disposeBag) // dispose it on deinit.
```
1. Khởi tạo observable thể hiện cho sự thay đổi nội dung của search bar
2. Lọc nội dụng bắt đầu bằng chuỗi `Number`
3. Subcrible một observable để có thể xử lý mỗi khi nội dung search bar thay đổi

### 2.4. Subjects <a name="Subjects"></a>

​	Một đối tượng vừa có thể là Observable vừa có thể là Observer được gọi là Subject.

​	Chẳng hạn khi sử dụng UIImagePickerController, ngoài việc quan tâm tới các hình ảnh mà người dùng chọn, ứng dụng cần tương tác với chính UIImagePickerController để ẩn, hiển, … như vậy không thể bọc UIImagePickerController bên trong Observable. Khi đó, Subject sẽ đóng vai trò cầu nối, giúp chuyển đổi các tương tác của người dùng thành các Observable tương ứng.

#### 2.4.1. PublishSubject

​	PublishSubject là các phần tử có thể được phát ngay sau khi Subject được khởi tạo, bất chấp chưa có đối tượng nào subscribe tới nó (hot observable). Observer sẽ không nhận được các phần tử phát ra trước thời điểm subscribe.

![PublishSubject-diagram](./resources/images/2.4/PublishSubject-diagram.png)

```swift
// Khởi tạo đối tượng PublishSubject.
let subject = PublishSubject<String>()

// subject phát đi event.
subject.onNext("Is anyone listening?")

// subscriptionOne đăng ký lắng nge đối tượng subject trên.
let subscriptionOne = subject.subscribe(onNext: { string in
	print("1)", string)
})

subject.onNext("1")
subject.onNext("2")

// subscriptionTwo đăng ký lắng nge đối tượng subject trên.
let subscriptionTwo = subject.subscribe { event in
	print("2)", event.element ?? event)
}

subject.onNext("3")

// deinit subscriptionOne
subscriptionOne.dispose()

subject.onNext("4")

// deinit subscriptionTwo
subscriptionTwo.dispose()
```

```swift
// Ouput:
1) 1
1) 2
1) 3
2) 3
2) 4
```

#### 2.4.2. BehaviorSubject

​	BehaviorSubject có cơ chế hoạt động gần giống với PublishSubject, nhưng Observer sẽ nhận được giá trị mặc định hoặc giá trị ngay trước thời điểm subscribe. Observer sẽ nhận được ít nhất một giá trị.

​	Chẳng hạn, nếu coi việc cuộn thanh trượt của UIScrollView là một observable (offset là giá trị của các phần tử trong stream), thì ngay khi subscribe vào observable, chúng ta cần biết vị trí offset hiện tại của UIScrollView, do vậy chúng ta cần sử dụng BehaviorSubject

#### ![BehaviorSubject-diagram](./resources/images/2.4/BehaviorSubject-diagram.png)

```swift
let disposeBag = DisposeBag()

// Khởi tạo đối tượng BehaviorSubject.
let subject = BehaviorSubject(value: "Initial value")

// subject phát đi event.
subject.onNext("1")

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
		print("1)", $0)
	}
	.disposed(by: disposeBag)

subject.onNext("2")

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
		print("2)", $0)
	}
	.disposed(by: disposeBag)

subject.onNext("3")
```

```swift
// Output:
1) 1
1) 2
2) 2
1) 3
2) 3
```

#### 2.4.3. ReplaySubject

​	ReplaySubject tương tự như BehaviorSubject nhưng thay vì phát thêm duy nhất một phần tử trước đó, ReplaySubject cho phép ta chỉ định số lượng phần tử tối đa được phát lại khi subscribe. Ngoài ra, khi khởi tạo ReplaySubject, chúng ta không cần khai báo giá trị mặc định như BehaviorSubject.

![ReplaySubject-diagram](./resources/images/2.4/ReplaySubject-diagram.png)

```swift
let disposeBag = DisposeBag()

// Khởi tạo đối tượng BehaviorSubject.
let subject = ReplaySubject<String>.create(bufferSize: 2)

// subject phát đi event.
subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
		print("1)", $0)
	}
	.disposed(by: disposeBag)

// Đăng ký lắng nge đối tượng subject trên.
subject.subscribe {
		print("2)", $0) 
	}
	.disposed(by: disposeBag)

subject.onNext("4")

// deinit subject
subject.dispose()
```

```swift
// Ouput:
1) 2
1) 3
2) 2
2) 3
1) 4
2) 4

```

#### 2.4.4. Variable

​	Variable là behaviour subject được gói lại để các lập trình viên mới làm quen với react có thể dễ tiếp cận hơn.

```swift
let disposeBag = DisposeBag()

// Khởi tạo đối tượng BehaviorSubject.
let variable = Variable("Initial value")

// subject phát đi event.
variable.value = "New initial value"

// Đăng ký lắng nge đối tượng subject trên.
variable.asObservable()
		.subscribe {
			print("1)", $0)
		}
		.disposed(by: disposeBag)

variable.value = "1"

// Đăng ký lắng nge đối tượng subject trên.
variable.asObservable()
		.subscribe {
			print("2)", $0)
		}
		.disposed(by: disposeBag)

variable.value = "2"
```

```swift
1) next(New initial value)
1) next(1)
2) next(1)
1) next(2)
2) next(2)
```

## 4. Testing <a name="testing"></a>

### 4.1. RxTest <a name="RxTest"></a>

### 4.2. RxNimble <a name="RxNimble"></a>

## 5. References <a name="References"></a>

https://github.com/ReactiveX/RxSwift
http://rxmarbles.com/
