//
//  PhotoWriter.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/23/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift

class PhotoWriter: NSObject {

    typealias Callback = (NSError?) -> Void
    private var callback: Callback
    let disposeBag = DisposeBag()

    init(callback: @escaping Callback) {
        self.callback = callback
    }

    static func save(_ image: UIImage) -> Observable<Void> {
        /* Observable<Void> will not emit any .next events; just an .error or a .completed. */
        return Observable<Void>.create { (observer) -> Disposable in
            let writer = PhotoWriter(callback: { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            })

            UIImageWriteToSavedPhotosAlbum(image, writer, #selector(PhotoWriter.image(_: didFinishSavingWithError: contextInfo:)), nil)
            return Disposables.create()
        }
    }

    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo info: UnsafeRawPointer) {
        callback(error)
    }
}
