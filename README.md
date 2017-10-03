[TOC]

## 0. Căn cơ

Nội dung bài này yêu cầu một số căn cơ nhất định, võ sinh vui lòng đọc lại trước khi bắt đầu, tránh tẩu hỏa nhập ma hoặc trách người ra đề đánh đố thí sinh.

### 0.1. Programming paradigm [?](https://en.wikipedia.org/wiki/Programming_paradigm)

- **imperative programming** - lập trình điều khiển

Mẫu hình lập trình sử dụng câu lệnh để thay đổi trạng thái của chương trình.

```swift
func fib(_ n: Int) -> Int {
    guard n > 1 else return n
    let a = 1
    let b = 1
    var c = 0
    for i in 1..<n {
        c = a + b
        a = b
        b = c
    }
    return c
}
```
- **functional programming** - lập trình hàm

Lập trình hàm nhấn mạnh việc ứng dụng hàm số / hàm dựng sẵn, trái với phong cách lập trình mệnh lệnh, nhấn mạnh vào sự thay đổi trạng thái.

Nguyên tắc của *functional programming*  là không thay đổi / duy trì ảnh hưởng đến trạng thái bên ngoài scope của nó (side effect).

*Functional programming* là một dạng của *declarative programming*.

```swift
func fib(_ n: Int) -> Int {
    guard n > 1 else return n
    return fib(n-1) + fib(n-2)
}
```

- **declarative programming** - which does not state the order in which operations execute

- **object-oriented programming** - which groups code together with the state the code modifies

- **procedural programming** - which groups code into functions

- **logic programming** - which has a particular style of execution model coupled to a particular style of syntax and grammar

- **symbolic programming** - which has a particular style of syntax and grammar

- **Software design pattern** [?](https://en.wikipedia.org/wiki/Software_design_pattern)
    Thường là một template mô tả cách giải quyết một vấn đề mà có thể được dùng trong nhiều tình huống khác nhau.
    > Các giải thuật không được xem là các mẫu thiết kế, vì chúng giải quyết các vấn đề về tính toán hơn là các vấn đề về thiết kế.

## 1. Approach

### 1.1. Delegation pattern (*Object-oriented programming*)

### 1.2. Callback programming

### 1.3. Promise programming

### 1.4. Functional programming

### 1.5. Reactive programming

### 1.6. Functional Reactive programming


## 2. Key Types

### 2.1. Observables

Trước tiên ta cần tìm hiểu Stream là gì? Stream là những dòng dữ liệu, để truyền tải dữ liệu trả về, lỗi và tín hiệu kết thúc của một tác vụ theo trình tự thời gian từ nơi phát ra tín hiệu tới nơi lắng nge (Subscribe).

Trong thế giới của RxSwift thì Stream nói trên được gọi là Observables.

Observables là một cái có thể phát ra thông báo khi có sự thay đổi.

- **Create**

  Array, String, Int, Dictionary,… trong RxSwift sẽ được convert sang observable sequence. Chúng ta có thể tạo observable sequence của bất cứ object nào conform Sequence protocol.

  ```swift
  let helloSequence = Observable.just("Hello Rx")
  let fibonacciSequence = Observable.from([0, 1, 1, 2, 3, 5, 8])
  let dictSequence = Observable.from([1: "Hello", 2: "World"])
  ```

- **Lifecycle**

  Trong vòng đời của 1 Observables, nó có thể không phát ra hoặc phát ra nhiều event.

  Trong RxSwift, một event là một enum type với 3 trạng thái:  

  - **.next(value: T):** Khi một giá trị hoặc một tập hợp các giá trị được thêm vào Observable sequence, nó sẽ tự động gởi next event đến các subscriber của nó.
  - **.error(error: Error)**: Nếu một lỗi bị gặp phải trong quá trình thực thi, một error event sẽ được phát đi. Điều nãy cũng sẽ ngắt luôn sequence. 
  - **.completed**: Nếu một sequence  kết thúc bình thường, nó sẽ gởi completed event đến subcriber.

  ```swift
  let helloSequence = Observable.from(["H", "e", "l", "l", "o"])
  let subscription = helloSequence.subscribe { event in
    switch event {
        case .next(let value):
            print(value)
        case .error(let error):
            print(error)
        case .completed:
            print("completed")
    }
  }
  /* Output:
  H e l l o 
  completed
  */
  ```

- **Dispose**

  Để giải phóng bộ nhớ, RxSwift sử dụng dispose hoặc disposeBag. 

  Nếu muốn cancel	 một subcription, chúng ta có thể gọi dispose trên nó hoặc chúng ta thêm subscription vào DisposeBag, DisposeBag sẽ cancel subcription một cách tự động trong phương thức deinit. 

  ```swift
  let bag = DisposeBag()
  let helloSequence = Observable.just("Hello Rx")
  let subscription = helloSequence.subscribe { (event) in
  	print(event.element)
  }
  // option 1
  subscription.dispose()
  // option 2
  subscription.addDisposableTo(bag)
  ```

### 2.2 Subject

Một subject là một trạng thái của Observable Sequence, chúng ta có thể subscribe và thêm các element vào nó một cách linh hoạt. Trong Rx có 4 loại Subject. 

- **2.2.1 Publish Subjects**

  Nhận được tất cả các event xảy ra sau khi subscribe.

- **2.2.2 Behavior Subjects**

  Một behavior subject sẽ gởi element mới nhất đến bất kỳ subscribe nào sau khi tiến hành subscribe nó.

- **2.2.3 Replay Subjects**

  Ta có thể lấy được nhiều hơn một trạng thái của sequence, có thể định nghĩa được bao nhiêu trạng thái thay đổi mình sẽ nhận được sau khi subscribe.

- **2.2.4 Variable **

  Variable là Behavior Subject được gói lại.


### 2.3. Operators

- **2.3.1 Filtering**

- **2.3.2 Transforming**

- **2.3.3 Combining**


### 2.4. RxCocoa

- **Basic UIKit controls**

- **Binding observables**


### 2.5. Testing


### 2.6. Extension

- **RxGesture**

- **RxRealm**

- **RxAlamofire**


## 3. Chú thích và tài liệu tham khảo