## Mục lục

- [0. Căn cơ](#prequensites)
    - [Programming paradigm](#programming-paradigm)
    - [Software design pattern](#software-design-pattern)
- [1. Tiếp cận](#1-approach)
  * [1.1. Delegation pattern (Object-oriented programming)](#11-delegation-pattern)
  * [1.2. Callback programming](#12-callback-programming)
  * [1.3. Promise programming](#13-promise-programming)
  * [1.4. Functional programming](#14-functional-programming)
  * [1.5. Reactive programming](#15-reactive-programming)
  * [1.6. Functional Reactive programming](#16-reactive-functional-programming)
- [2. Lý thuyết](#2-theory)
    * [2.1. Observables](#21-observables)
        + [2.1.1. Lifecycle](#211-lifecycle)
        + [2.1.2. Create](#212-create)
        + [2.1.3. Next](#213-next)
        + [2.1.4. Error](#214-error)
        + [2.1.5. Complete](#215-complete)
        + [2.1.6. Desposed](#216-desposed)
  * [2.2. Subject](#22-subject)
    + [2.2.1. Publish Subjects](#221-publish-subjects)
    + [2.2.2. Behavior Subjects](#222-behavior-subjects)
    + [2.2.3. Replay Subjects](#223-replay-subjects)
  * [2.3. Operators](#23-operators)
    + [2.3.1. Filtering](#231-filtering)
    + [2.3.2. Transforming](#232-transforming)
    + [2.3.3. Combining](#233-combining)
  * [2.4. RxCocoa](#24-rxcocoa)
    + [2.4.1. Basic UIKit controls](#241-basic-uikit-controls)
    + [2.4.2. Binding observables](#242-binding-observables)
  * [2.5. Testing](#25-testing)
  * [2.6. Extension](#26-extension)
    + [2.6.1. RxGesture](#261-rxgesture)
    + [2.6.2. RxRealm](#262-rxrealm)
    + [2.6.3. RxAlamofire](#263-rxalamofire)
- [3. Chú thích và tài liệu tham khảo](#notes-and-references)


## 0. Căn cơ

Nội dung bài này yêu cầu một số căn cơ nhất định, võ sinh vui lòng đọc lại trước khi bắt đầu, tránh tẩu hỏa nhập ma hoặc trách người ra đề đánh đố thí sinh.

- Programming paradigm [?](https://en.wikipedia.org/wiki/Programming_paradigm)
    <details><summary>*imperative programming* - lập trình điều khiển</summary>
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
    </details>
    
    <details><summary>*functional programming* - lập trình hàm</summary>
    - Lập trình hàm nhấn mạnh việc ứng dụng hàm số / hàm dựng sẵn, trái với phong cách lập trình mệnh lệnh, nhấn mạnh vào sự thay đổi trạng thái.
    - Nguyên tắc của *functional programming*  là không thay đổi / duy trì ảnh hưởng đến trạng thái bên ngoài scope của nó (side effect).
    - *Functional programming* là một dạng của *declarative programming*.
    
    ```swift
    func fib(_ n: Int) -> Int {
        guard n > 1 else return n
        return fib(n-1) + fib(n-2)
    }
    ```
    </details>
    
    <a name="declarative-programming"></a><details><summary>*declarative* which does not state the order in which operations execute</summary>
    </details>
    
    <details><summary>*object-oriented programming* which groups code together with the state the code modifies</summary>
    </details>
    
    <details><summary>*procedural programming* which groups code into functions</summary>
    </details>
    
    <details><summary>*logic programming* which has a particular style of execution model coupled to a particular style of syntax and grammar</summary>
    </details>
    
    <details><summary>*symbolic programming* which has a particular style of syntax and grammar</summary>
    </details>

- Software design pattern [?](https://en.wikipedia.org/wiki/Software_design_pattern)
    - 

## 1. Tiếp cận<a name="approach"></a>

### 1.1. Delegation pattern

### 1.2. Callback programming

### 1.3. Promise programming

### 1.4. Functional programming

### 1.5. Reactive programming

### 1.6. Functional Reactive programming


## 2. Components<a name="components"></a>


### 2.1. Observables

#### 2.1.1 Lifecycle

#### 2.1.2 Create

#### 2.1.3 Next

#### 2.1.4 Error

#### 2.1.5 Complete

#### 2.1.6 Desposed


### 2.2 Subject

#### 2.2.1 Publish Subjects

#### 2.2.2 Behavior Subjects

#### 2.2.3 Replay Subjects


### 2.3. Operators

#### 2.3.1 Filtering

#### 2.3.2 Transforming

#### 2.3.3 Combining


### 2.4. RxCocoa

#### 2.4.1 Basic UIKit controls

#### 2.4.2 Binding observables


### 2.5. Testing


### 2.6. Extension

#### 2.6.1 RxGesture

#### 2.6.2 RxRealm

#### 2.6.3 RxAlamofire


## 3. Chú thích và tài liệu tham khảo<a name="notes-and-references"></a>
