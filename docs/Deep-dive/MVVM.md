### MVVM with RxSwift

#### MVVM
![MVVM-structure](./Operators/resources/images/3.3/MVVM-structure.png)

ViewModel là trung tâm của mô hình MVVM, nó tập trung vào xử lý bussiness logic, có thể tương tác với cả model và view
- Model không tương tác trực tiếp với View mặc dù nó có thể emit các event khi có thay đổi data
- ViewModel tương tác và lắng nghe Model sau đó phát sự kiện đẩy dữ liệu đến View(Controller) để update UI component
- View Controllers chỉ tương tác với ViewModel và View qua các tác vụ như xử lý lifecycle của View và bind data vào UI controls bằng đăng ký lắng nghe các sự kiện từ ViewModel
- View chỉ notify ViewController về sự kiện như touch, tap, didSelect cell ..., chỗ này có thể dùng theo những cách thông thường như NotificationCenter, Delegate ... hoặc có cũng có thể dùng `Observable<T>` với T là kiểu sự kiện được định nghĩa.(Tham khảo *RxCocoa*)

*-> Chúng ta có xu hướng làm cho View Controller mỏng hơn(thinner), đơn giản hơn như đúng với tên gọi của nó , hãy đặt presentation logic thay vì bussiness logic trong View Controller. Điều này có thể được thực hiện một cách nhanh chóng và hiệu quả với RxSwift*

#### MVVM with RxSwift

Mô hình MVVM làm việc rất tốt với RxSwift vì nó có khả năng binding observables vào UI component

```swift
struct HomeViewModel {
	var venues: Variable<[Venue]> = Variable([])
	
	func fetchData() {
		// Thêm, chèn, xóa các venue và emit event để controller nhận và xử lý UI
	}
	
	func removeFirst() {
		venues.value.removeFirst()
	}
}

class HomeViewController: UIViewController {
	let viewModel = HomeViewModel()
	
	override func viewDidload() {
		bind()
	}
	
	func bind() {
		viewModel.bind(to // tableView, collectionView ...
		/*
		 Kể từ đây, mình không cần quan tâm nhiều tới presentation logic nữa
		 */
	}
	
	private func removeFirst() {
		viewModel.data.removeFirst() // or viewModel.removeFirst()
		/*
		 Table view sẽ tự động delete cell đầu tiền
		 */
	}
}
```



Chúng ta cũng có thể binding ngược lại từ UI component vào ViewModel bằng cách dùng thư viện *RxCocoa*

```swift
        usernameTextField.rx.text.bindTo(viewModel.username)
```



#### Input and output
- Thường thì chúng ta dùng hàm `init` với các tham số để khởi tạo ViewModel, hoặc dùng các `public property`
- Dùng các functions có kiểu trả về là `Observable<T>` hoặc `public property` có kiểu `Observable<T>` để Model hoặc View có thể subscribe và xử lý khi có event được phát ra
