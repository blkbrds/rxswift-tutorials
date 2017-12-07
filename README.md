**Reactive Programming with Swift**

> Mọi chia sẻ hay sao chép phải được cấp phép, tác quyền thuộc team iOS - Asian Tech, Inc

# Contents

1. [Get Started](#get-started)
	1. [Reactive](#Reactive)
	2. [Observable - starter](#Observable-starter)
	3. [Observer - handler](#Observer-handler)
	4. [Operator - man in the middle](#Operator-man-in-the-middle)
	5. [Subjects](#Subjects)

2. [Deep Dive](docs/Deep-dive)
	1. [Creation](docs/Deep-dive/Creation.md)
	2. [Operators](docs/Deep-dive/Operators)
	3. [MVVM](docs/Deep-dive/MVVM.md)

3. Advanced(Update later)

4. [Testing](docs/Testing.md)
	1. [RxTests](#RxTests)
	2. [RxNimble](#RxNimble)(Update later)

## 1. Getting Started <a name="get-started"></a>
### 1.1. Reactive <a name="Reactive"></a>

**Reactive programming là gì?**

 **Reactive programming is programming with asynchronous data streams.**

*Reactive programming* là phương pháp lập trình với luồng dữ liệu bất đồng bộ hay những thay đổi có tính lan truyền (the propagation of change). Khái niệm luồng (stream) rất phổ biến, bạn có thể tạo luồng dữ liệu (data streams) từ bất cứ thứ gì (anything can be a stream): các biến (variables), giá trị đầu vào từ người dùng (user inputs), properties, caches, data structures, etc.
Streams là trung tâm của `reactive`.

Một luồng là một dãy (sequence) các sự kiện đang diễn ra được sắp xếp theo thời gian. Nó có thể phát ra 3 thứ: một `value`, một `error`, hoặc một `completed`. 

Để minh họa cho stream người ta hay dùng một loại biểu đồ gọi là [marble diagram](http://rxmarbles.com/), loại diagram này rất đơn giản, trực quan và dễ hiểu.
Mô hình dưới đây là luồng sự kiện "click vào 1 button"

![reactive](./resources/images/1.5/reactive.png)

Ở đây tín hiệu giúp ta biết được khi nào luồng sự kiện click `completed` là khi window hoặc view chứa button bị đóng lại.

Chúng ta bắt các sự kiện **bất đồng bộ** (ví dụ như tap vào button, call API, ...) bằng cách define một function execute khi một giá trị được phát ra, một function khác khi error được phát ra, tương tự với `completed`. Các function chúng ta define là các observer, luồng(stream) là chủ thể đang được lắng nghe(being observed) hay còn gọi là `Observable`.

Xem thêm một ví dụ được vẽ bằng mã ASCII sau:

```groovy
--a---b-c---d---X---|->

a, b, c, d là các giá trị được phát ra
X là một error nào đó
| là một signal 'completed'
```
> Ta có thể xem đây là một stream

### 1.2. Observable - starter <a name="Observable-starter"></a>

> Khái niệm Observable đến từ observer design pattern là một đối tượng thông báo cho các đối tượng theo dõi về một điều gì đó đang diễn ra. [source](https://xgrommx.github.io/rx-book/content/observable/index.html#)

- Diagram dưới đây biểu diễn  `Observable` và quá trình biến đổi của `Observable`:

![Observable-diagram](./resources/images/2.1/Observable-diagram.png)

- Một `Observer` đăng ký lắng nghe một `Observable` sau đó `Observer` sẽ phản ứng lại bất cứ item hay chuỗi các item mà `Observable` phát ra. Phần này sẽ giải thích cụ thể reactive parttern là gì, cách thức hoạt động ra sao.

#### 1.2.1 Mở đầu

- Có rất nhiều thuật ngữ dùng để mô tả mô hình và thiết kế của lập trình bất đồng bộ. Trong tài liệu này sẽ thống nhất sử dụng những thuật ngữ sau: 
  - Một `Observer` đăng ký với `Observable`.
  - Một `Observable` phát ra các items hoặc gửi các notifications đến các `Observer` bằng cách gọi các `Observer` methods.

#### 1.2.2 Khởi tạo `Observer`

- Trong mô hình bất đồng bộ, flow sẽ giống như sau:

  1. Khai báo một method có giá trị được trả về từ một hàm gọi bất đồng bộ, method này là một phần của `*Observer*`.
  2. Khai báo một `*Observable*`, 
  3. Đăng kí `observer` vào `Observable`  (*subscribing* it) .
  4. Method của `Observer` sẽ bắt đầu xử lý các business logic dựa trên giá trị trả về hoặc các giá trị được phát ra bởi `Observerble`.

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

  ​	[`Subscribe` method](http://reactivex.io/documentation/operators/subscribe.html) là cách bạn kết nối `Observer` với `Observable`. Observer's implementation là tập hợp các methods dưới đây:

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

  Khi nào `observable` phát ra chuỗi các `items`? Điều đó phụ thuộc vào `Observable`. Một "hot" Observable có thể bắt đầu phát các items ngay khi nó được tạo ra, và sau đó bất kỳ `Observer` nào đăng ký tới `observable` đều có thể bắt đầu quan sát (observing) từ khoản giữa của tiến trình . Trái lại, "Cold" observable thì chờ cho đến khi một `observer` nào đó đăng kí vào `observable` trước khi nó bắt đầu phát ra các items, và do đó `observer` có thể đảm bảo được việc quan sát từ toàn bộ tiến trình từ lúc bắt đầu ( to see the whole sequence from the beginning.)

  [Read more](http://reactivex.io/documentation/observable.html)

### 1.3. Observer - handler <a name="Observer-handler"></a>

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



### 1.4. Operator - man in the middle <a name="Operator-man-in-the-middle"></a>
Operators là những phép toán cho phép biển đổi observable thành observable mới để phù hợp với nhu cầu sử dụng

Một số operators cơ bản trong RxSwift được liệt kê [tại đây](docs/deep-dive/operators)

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

### 1.5. Subjects <a name="Subjects"></a>

> Một đối tượng vừa có thể là Observable vừa có thể là Observer được gọi là Subject.

​Chẳng hạn khi sử dụng UIImagePickerController, ngoài việc quan tâm tới việc load hình ảnh từ Photos Library (lúc này UIImagePickerController là Observer) thì ứng dụng cần tương tác với chính UIImagePickerController để ẩn, hiển, chọn ảnh… (lúc này UIImagePickerController là Observable). Vậy ta có thể hiểu UIImagePickerController là một Subject
​
#### 1.5.1. PublishSubject

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

#### 1.5.2. BehaviorSubject

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

#### 1.5.3. ReplaySubject

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

#### 1.5.4. Variable

Variable là một kiểu của BehaviorSubject mà có thể lưu giữ giá trị(Value) hiện tại như một trạng thái(state). Chúng ta có thể truy cập vào giá trị hiện tại đó thông qua thuộc tính `value`, việc thay đổi `value` này tương đương với hàm `onNext` của các loại subject khác

- Không thể add sự kiện error vào một Variable
- Không thể add sự kiện completed vào một Variable, sự kiện này chỉ được phát ra khi nó bị deallocated

Chúng ta rất hay dùng subject kiểu Variable, đặc biệt là trong các trường hợp không cần quan tâm tới việc khi nào có error và khi nào completed

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
## 2. [Deep Dive](docs/Deep-dive)
Sau khi tìm hiểu các khái niệm cơ bản của Reactive programming và RxSwift thì trong phần này, chúng ta sẽ đi sâu hơn vào cách hoạt động, xử lý và ứng dụng trong từng trường hợp cụ thể của chúng.

  1. [Creation](docs/Deep-dive/Creation.md)
  2. [Operators](docs/Deep-dive/Operators)
  3. [MVVM](docs/Deep-dive/MVVM.md)

## 3. Advanced(Update later)

## 4. Testing <a name="testing"></a>
Phần này sẽ tập trung vào implement Unit-Testing bằng các framework trên RxSwift Community như `RxTests`, `RxBlocking`, `RxNimble`

### 4.1. [RxTests](docs/Testing.md) <a name="RxTests"></a> 

### 4.2. RxNimble <a name="RxNimble"></a> (Update later)

## References <a name="References"></a>

https://github.com/ReactiveX/RxSwift
http://rxmarbles.com/
