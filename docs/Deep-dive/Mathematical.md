
- **toArray**

  Chuyển một chuỗi có thể quan sát được thành một mảng tập hợp. 

  ![toArray-diagram](./resources/images/3.2.4/toArray-diagram.png)

  ```swift
  let disposeBag = DisposeBag()
  Observable.of(1, 2, 3, 5)
            .toArray()
            .subscribe({ print("1235 em có đánh rơi nhịp nào không?", $0) })
            .disposed(by: disposeBag)
  ```

  ```swift
  // Output:
  1235 em có đánh rơi nhịp nào không? [1, 2, 3, 5]
  ```



- **reduce**

  Tính toán dựa trên giá trị ban đầu và các toán tử +, -, *, /, … chuyển đổi thành một observable 

  ![reduce-diagram](./resources/images/3.2.4/reduce-diagram.png)

  ```swift
  let disposeBag = DisposeBag()
  Observable.of(1, 2, 3, 4, 5)
            .reduce(1, accumulator: +)
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
  ```

  ```swift
  // Output:
  15
  ```

