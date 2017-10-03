## Mục lục

- [0. Căn cơ](#prequensites)
    * [Programming paradigm](#programming-paradigm)
    * [Software design pattern](#software-design-pattern)
- [1. Approach](#1-approach)
    * [1.1. Delegation pattern (*Object-oriented programming*)](#11-delegation-pattern)
    * [1.2. Callback programming](#12-callback-programming)
    * [1.3. Promise programming](#13-promise-programming)
    * [1.4. Functional programming](#14-functional-programming)
    * [1.5. Reactive programming](#15-reactive-programming)
    * [1.6. Functional Reactive programming](#16-functional-reactive-programming)
- [2. Key Types](#2-key-types)
    * [2.1. Observables](#21-observables)        
    * [2.2. Subject](#22-subject)        
    * [2.3. Operators](#23-operators)
    * [2.4. RxCocoa](#24-rxcocoa)
    * [2.5. Testing](#25-testing)
    * [2.6. Extension](#26-extension)
- [3. Chú thích và tài liệu tham khảo](#notes-and-references)


## 0. Căn cơ <a name="prequensites">

Nội dung bài này yêu cầu một số căn cơ nhất định, võ sinh vui lòng đọc lại trước khi bắt đầu, tránh tẩu hỏa nhập ma hoặc trách người ra đề đánh đố thí sinh.

- **Programming paradigm** [?](https://en.wikipedia.org/wiki/Programming_paradigm) <a name="programming-paradigm">

    <details>
    <summary><i>imperative programming</i> - lập trình điều khiển</summary>
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
    
    <details>
    <summary><i>functional programming</i> - lập trình hàm</summary>
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
    
    <details>
    <summary><i>declarative</i> - which does not state the order in which operations execute</summary>
    </details>
    
    <details>
    <summary><i>object-oriented programming</i> - which groups code together with the state the code modifies</summary>
    </details>
    
    <details>
    <summary><i>procedural programming</i> - which groups code into functions</summary>
    </details>
        
    <details>
    <summary><i>logic programming</i> - which has a particular style of execution model coupled to a particular style of syntax and grammar</summary>
    </details>
        
    <details>
    <summary><i>symbolic programming</i> - which has a particular style of syntax and grammar</summary>
    </details>

- **Software design pattern** [?](https://en.wikipedia.org/wiki/Software_design_pattern)<a name="software-design-pattern"></a>
    Thường là một template mô tả cách giải quyết một vấn đề mà có thể được dùng trong nhiều tình huống khác nhau.
    > Các giải thuật không được xem là các mẫu thiết kế, vì chúng giải quyết các vấn đề về tính toán hơn là các vấn đề về thiết kế.

## 1. Approach<a name="1-approach"></a>

### 1.1. Delegation pattern (*Object-oriented programming*)<a name="11-delegation-pattern"></a>

### 1.2. Callback programming

### 1.3. Promise programming

### 1.4. Functional programming

### 1.5. Reactive programming

### 1.6. Functional Reactive programming


## 2. Key Types<a name="2-key-types"></a>


### 2.1. Observables

- **Lifecycle**

- **Create**

- **Next**

- **Error**

- **Complete**

- **Desposed**


### 2.2 Subject

- **Publish Subjects**

- **2.2.2 Behavior Subjects**

- **2.2.3 Replay Subjects**


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


## 3. Chú thích và tài liệu tham khảo<a name="notes-and-references"></a>
