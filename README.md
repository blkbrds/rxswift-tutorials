[TOC]

## 0. Căn cơ

Nội dung bài này yêu cầu một số căn cơ nhất định, võ sinh vui lòng đọc lại trước khi bắt đầu, tránh tẩu hỏa nhập ma hoặc trách người ra đề đánh đố thí sinh.



### Programming paradigm [?](https://en.wikipedia.org/wiki/Programming_paradigm)

<details><summary><b>imperative programming</b> - lập trình điều khiển</summary>
Mẫu hình lập trình sử dụng câu lệnh để thay đổi trạng thái của chương trình.

```swift
func main(_ n: Int) -> Int {
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
</details>

<details><summary><b>functional programming</b> - lập trình hàm</summary>
Lập trình hàm nhấn mạnh việc ứng dụng hàm số / hàm dựng sẵn, trái với phong cách lập trình mệnh lệnh, nhấn mạnh vào sự thay đổi trạng thái.

Nguyên tắc của *functional programming*  là không thay đổi / duy trì ảnh hưởng đến trạng thái bên ngoài scope của nó (side effect).

*Functional programming* là một dạng của *declarative programming*.

```swift
func fib(_ n: Int) -> Int {
  guard n > 1 else return n
  return fib(n-1) + fib(n-2)
}

func main(_ n: Int) -> Int {
  return fib(n)
}
```
</details>

<details><summary><b>declarative programming</b> - ngược lại với <b>imperative programming</b>, dùng các hàm dựng sẵn để ẩn đi tiến trình thực hiện, chỉ quan tâm đến đầu vào, đầu ra</summary>

```swift
let a = [1, 2, 3]
let b = a.map{ fib($0) }
```

</details>

<details><summary><b>object-oriented programming</b> - which groups code together with the state the code modifies</summary>
</details>

<details><summary><b>procedural programming</b> - which groups code into functions</summary>
</details>

<details><summary><b>logic programming</b> - which has a particular style of execution model coupled to a particular style of syntax and grammar</summary>
</details>

<details><summary><b>symbolic programming</b> - which has a particular style of syntax and grammar</summary>
</details>



### Software design pattern [?](https://en.wikipedia.org/wiki/Software_design_pattern)

Thường là một template mô tả cách giải quyết một vấn đề mà có thể được dùng trong nhiều tình huống khác nhau.
> Các giải thuật không được xem là các mẫu thiết kế, vì chúng giải quyết các vấn đề về tính toán hơn là các vấn đề về thiết kế.



## 1. Approach



### 1.1. Delegation pattern (*Object-oriented programming*)

```swift
let app = App()
let worker = 
```

### 1.2. Callback programming



### 1.3. Promise programming



### 1.4. Functional programming



### 1.5. Reactive programming



### 1.6. Functional Reactive programming



## 2. Concepts

> put the diagram here



## 3. Chú thích và tài liệu tham khảo



