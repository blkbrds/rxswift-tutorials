
Rất vui khi chúng ta đã đi qua hơn một nữa chặn đường tìm hiểu về `RxSwift`. Tới đây thì chúng ta cảm thấy `RxSwift` không quá khó đúng không?

> Phần này được coi là một trong những phần quan trọng nhất của `Rxswift` nhé.

Sơ lượt, những toán tử thuộc *Transformation* giúp chúng ta biến đổi một **observable**.

Vâng... giúp biến đổi, nhưng biến đổi thành cái gì và biến đổi như thế nào ???

Còn tùy… OK, mình sẽ dẫn chứng cho các bạn biết vì sao lại *còn tùy*.

Có một điều là lâu nay mọi người vẫn đang và đã sài vài phép biến đổi này trong *Swift*, *chúng nó* là **hàm** *native* do **Apple** cung cấp hẳn hoi nhé.

Một số *toàn tử* đó là **map**, **flatMap**, …. Đấy, nếu dùng rồi thì mọi người sẽ nhận ra rằng biến đổi thành gì và như thế nào rõ ràng là do chính bạn, bạn mong muốn gì thì bạn làm thôi.

> Trên đó chỉ là một cách dẫn chứng cho mọi người có thể dễ dàng hình dung về **Transformation** thôi.
>
> Chứ trong thực tế **map**, **flatMap** hay một vài hàm khác do *Apple* cung cấp khác với các toán tử cùng tên trong `RxSwift` nha. Sau khi xong phần này mọi người tự so sánh để biết được khác biệt đó ở đâu nha.



OK,,, bắt đầu với **Transformation** nào.

**`buffer`**:

Cứ theo chu kỳ, những *item* được bắn ra từ **observable** sẽ tập hợp lại thành một gói theo số lượng buffer trước. Điều đó có nghĩa là thay vì bắn ra riêng lẻ từng item thì sau khi dùng `buffer` sẽ bắn ra từng gói (mỗi gói sẽ có nhiều item).

![buffer](./resources/images/3.2.5/buffer.png)

Sau đây là code ví dụ về `buffer`:

```swift
_ = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
		.map { Int($0) }
		.buffer(timeSpan: 1, count: 10, scheduler: MainScheduler.instance)
		.subscribe({ (value) in
			print(value)
		})
```

Chú ý tới toán tử buffer thì có tham số `timeSpan` và `count`, chính xác thì 2 tham số này quy định cái *gói* chứa *item* sẽ to bao nhiêu. 

​	**count**: số lượng item trong 1 *gói*

​	**timeSpan**: tổng thời gian có thể có để chứa các item. (Hãy tưởng tượng thế này, cái bao của bạn chỉ có 1s để hứng các *item* thôi, thì giả sử **count** là không giới hạn thì trong item nào được phát ra trong khoảng thời gian 1s đó thì được cho vào gói đó, nếu phát ra ở giây sau đó thì vào gói sau).

Khai chạy code trên thì kết quả như sau:

```swift
next([0, 1, 2, 3, 4, 5, 6, 7, 8])
next([9, 10, 11, 12, 13, 14, 15, 16, 17, 18])
next([19, 20, 21, 22, 23, 24, 25, 26, 27, 28])
next([29, 30, 31, 32, 33, 34, 35, 36, 37, 38])
next([39, 40, 41, 42, 43, 44, 45, 46, 47, 48])
```



**`map`**:

Biến đổi từng *item* của một **observable** để trở thành một **observable** mới.

![map](./resources/images/3.2.5/map.png)

Như *diagram* trên thì mỗi *item* đều được biến đổi bằng các nhân với 10.

Dưới đây là code ví dụ cho *diagram* trên:

```swift
let observable = Observable<Int>.of(1, 2, 3)
observable.map { $0 * 10 }
	.subscribe(onNext: { value in
		print(value)
	}).dispose()
```

Kết quả:

```swift
10
20
30
```



**`flatMap`**:

Giúp chúng ta làm *phẳng* các *item* vào một **observable** duy nhất.

Nhìn kỹ *diagram* dưới thì mọi người sẽ thấy ban đầu **observable** sẽ *emit* ra những *item* mà những *item* này có thể là 1 **observable** khác, thì sau khi dùng `flatMap` mọi *item* sẽ được làm phẳng ra trong 1 **observable** duy nhất.

![flatMap](./resources/images/3.2.5/flatMap.png)



Sau đây là một ví dụ cho `flatMap`:

```swift
let disposeBag = DisposeBag()

struct Player {
    var score: Variable<Int>
}

let 👦🏻 = Player(score: Variable<Int>(80))
let player = Variable(👦🏻)
player.asObservable()
    .flatMap { $0.score.asObservable() }
    .subscribe(onNext: { print("score: \($0)") })
    .disposed(by: disposeBag)
player.asObservable()
    .flatMap({ $0.score.asObservable().map({ $0 * 10 })})
    .subscribe(onNext: { print("score: \($0)") })
    .disposed(by: disposeBag)
```

Kết quả: 

```swift
score: 80
score: 800
```



**`groupBy`**:

Chia một **observable** thành một tập các **observable** khác theo một điều kiện nào đó.

![groupBy](./resources/images/3.2.5/groupBy.png)

Hãy thử ví dụ sau để có thể hiểu hơn về `groupBy`:

```swift
// Define một struct `Message`
struct Message {
    var id: Int
    var msgContent: String
    var date: String
    var isRead: Bool
}

// Setup một mảng messages
let messages = [
    Message(id: 1001, msgContent: "TextContent1", date: "2017-01-01", isRead: true),
    Message(id: 1002, msgContent: "TextContent2", date: "2017-01-01", isRead: false),
    Message(id: 1003, msgContent: "TextContent3", date: "2017-01-01", isRead: true),
    Message(id: 1004, msgContent: "TextContent4", date: "2017-01-01", isRead: false),
    Message(id: 1005, msgContent: "TextContent5", date: "2017-01-01", isRead: false),
    Message(id: 1006, msgContent: "TextContent6", date: "2017-01-01", isRead: true)
]

// Tạo một observable sau đó group theo cờ `isRead`
let source = Observable.from(messages)
let group = source.groupBy { $0.isRead }

// ****
group
    .map({ (item) -> Observable<Message> in
        if item.key {
            return item.asObservable()
        }
        return Observable<Message>.of()
    })
    .flatMap({ $0.asObservable() })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

Kết quả:

```swift
Message #1(id: 1001, msgContent: "TextContent1", date: "2017-01-01", isRead: true)
Message #1(id: 1003, msgContent: "TextContent3", date: "2017-01-01", isRead: true)
Message #1(id: 1006, msgContent: "TextContent6", date: "2017-01-01", isRead: true)
```



**`scan`**:

Các *item* được bắn ra sau khi được biến đổi dựa trên giá trị của *item* trước đó, và sẽ dựa vào giá trị ban đầu được cung cấp nếu là *item* đầu tiên.

Xem *diagram* sau đây:

![groupBy](./resources/images/3.2.5/scan.png)

Một đoạn code demo cho *diagram* trên:

```swift
let observable = Observable<Int>.of(1, 2, 3, 4, 5)
observable
    .scan(0) { (seed, value) -> Int in
        return seed + value
    }
    .toArray()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
```

```swift
[1, 3, 6, 10, 15]
```



**`window`**:

![groupBy](./resources/images/3.2.5/window.png)

Tương tự với `buffer` được cung cấp ở đầu phần này, nhưng khác biệt ở chổ là các *item* sẽ được chia vào các **observable** thay vì là ***MỘT*** **observable** với các *item* là mảng giá trị.

```swift
_ = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        .map { Int($0) }
        .window(timeSpan: 1, count: 10, scheduler: MainScheduler.instance)
        .flatMap({ $0 })
        .subscribe({ (value) in
            print(value)
        })
```



```swift
next(0)
next(1)
next(2)
next(3)
next(4)
next(5)
next(6)
next(7)
next(8)
next(9)
next(10)
next(11)
```

Đấy rất khác…..



Ok,,, các bạn đã đi hết phần này.

Tuy nhiên trên đó mình chỉ liệt kê ra những toán tử điển hình và hay dùng, mọi người tự tìm hiểu thêm về những toán tử còn lại nha.
