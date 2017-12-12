//
//  UIImageViewExt.swift
//  FS
//
//  Created by Quang Phu C. M. on 12/12/17.
//  Copyright © 2017 thinhxavi. All rights reserved.
//

import UIKit
import RxSwift

extension UIImageView {
    func setImage(path: String?) -> Observable<UIImage> {
        return Observable<UIImage>.create({ (observer) -> Disposable in

            guard let url = URL(string: path ?? "") else {
                let error = NSError(message: "Path is nil")
                observer.onError(error)
                return Disposables.create()
            }
            let disposable = URLSession.shared.rx.data(request: URLRequest(url: url))
                .observeOn(MainScheduler.instance)
                .subscribe({ (event) in
                switch event {
                case .next(let data):
                    if let image = UIImage(data: data) {
                        self.image = image
                        observer.onNext(image)
                    } else {
                        observer.onError(RxError.unknown)
                    }
                case .error(let error):
                    observer.onError(error)
                case .completed:
                    observer.onCompleted()
                }
            })
            return disposable
        })
    }
}
