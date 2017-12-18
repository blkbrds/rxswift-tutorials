//
//  Reactive+Extension.swift
//  FS
//
//  Created by at-thinhuv on 11/28/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

public extension ObservableType {
    public func withHUD() -> Observable<Self.E> {
        return self.do(onNext: nil, onError: { (error) in
            DispatchQueue.main.async {
                SVProgressHUD.showInfo(withStatus: error.localizedDescription)
            }
        }, onCompleted: {
            dismissHUD()
        }, onSubscribe: nil, onSubscribed: {
            showHUD()
        }, onDispose: {
            dismissHUD()
        })
    }

    public func unwrap<T>() -> Observable<T> where E == Optional<T> {
        return self.filter { $0 != nil }.map { $0! }
    }
}

extension Reactive where Base: UIBarButtonItem {
    public var title: UIBindingObserver<Base, String?> {
        return UIBindingObserver(UIElement: self.base) { barButtonItem, title in
            barButtonItem.title = title
        }
    }
}
