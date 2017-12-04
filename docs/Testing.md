# Testing

## RxTest

### What is RxTest

RxTest là một test framework mở rộng từ `RxSwift`. Hầu hết các dự án có Unit Test + RxSwift thì đều sử dụng **RxTest**

```bash
target 'FSTests' do
    inherit! :search_paths
    pod 'RxTest', '3.6.1'
end
```

### Main Classes

Trước hết, muốn sử dụng **RxTest** cần hiểu một vài khái niệm cơ bản trong **RxTest**.

> Virtual time - thời gian ảo. Mỗi observable đều có một timeline, và trong RxTest có `virtual time` nhằm mục đích giúp chúng ta xác định được khi nào một Observable được subscribe hay unsubcribe, hay lúc nào Observable phát ra một sự kiện, khi nào thì **completion** hay **error**.

#### TestScheduler

`The main component of RxTest`  - là một *virtual time scheduler* giúp chúng ta control time cho việc test với Rx dễ dàng.

Một đối tượng TestScheduler có các functions để khởi tạo các **TestableObserver** và **TestObservable**.

#### TestableObservable

Là một **Observable sequence** mà các events của nó được gửi tới `observer` tại một thời điểm đã được xác định (tất nhiên là virtual time), và **TestableObservable** được `records` lại những lúc nó được subscribe hay unsubscribe trong suốt timeline của nó.

#### TestableObserver

Là một **Observer** mà ghi lại tất cả các sự kiện đã được phát ra cùng với `virtual time` khi mà nó nhận được sự kiện.

### Examples

```swift
import XCTest
import RxSwift
import RxTest

class FSTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testMapObservable() {

        // 1. Khởi tạo TestScheduler với initial virtual time 0
        let scheduler = TestScheduler(initialClock: 0)

        // 2. Khởi tạo TestableObservable với type Int
        // và định nghĩa `virtual time` cùng với `value`
        let observable = scheduler.createHotObservable([
            next(150, 1),  // (virtual time, value)
            next(210, 0),
            next(240, 4),
            completed(300)
            ])

        // 3. Khởi tạo TestableObserver
        let observer = scheduler.createObserver(Int.self)

        // 4. Sẽ thực hiện subcribe `Observable` tại thời điểm 200 (virtual time)
        scheduler.scheduleAt(200) {
            observable.map { $0 * 2 }
                .subscribe(observer)
                .addDisposableTo(self.disposeBag)
        }

        // 5. Start `scheduler`
        scheduler.start()

        // Events mong muốn
        let expectedEvents = [
            next(210, 0 * 2),
            next(240, 4 * 2),
            completed(300)
        ]

        // 6-1. So sánh events mà observer nhận được và events mong muốn
        XCTAssertEqual(observer.events, expectedEvents)

        // Bonus thêm 😎😎😎
        // Thời gian subcribed và unsubcribed mong muốn
        let expectedSubscriptions = [
            Subscription(200, 300)
        ]

        // 6-2. So sánh virtual times khi `observable` subscribed và unsubscribed
        XCTAssertEqual(observable.subscriptions, expectedSubscriptions)
    }
}
```

Có thể xem thêm ví dụ ở [ViewModelTests](FS/FSTests/ViewModelTests.swift)

## RxBlocking

Hiện tại áp dụng `RxBlocking` cho việc testing API Request.

Sử dụng method `toBlocking()` của **RxBlocking** để *block* thread hiện tại, và đợi Observable hoàn thành.

```swift
func testDataWhenFetchAPI() {
        let service = NumberService()
        let viewModel = ViewModel(service: service)
        let result = try! viewModel.fetch().toBlocking().last()
        XCTAssertEqual(result, 1)
}
```

