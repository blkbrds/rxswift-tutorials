//
//  CustomObservableController.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/23/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomObservableController: BaseViewController {

    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var clearButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    var photo: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        clearButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                guard let this = self else { return }
                this.previewImageView.image = nil
                this.photo = nil
            })
            .disposed(by: disposeBag)

        saveButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] (_) in
                guard let this = self else { return }
                this.savePhoto()

            })
            .disposed(by: disposeBag)
    }

    private func savePhoto() {
        guard let photo = self.photo else {
            showAlert(message: "Please choose photo to save.")
            return
        }

        /*** PhotoWriter is example for Custom Observable ***/
        PhotoWriter.save(photo)
            .subscribe(
                onError: { [weak self] (error) in
                    guard let this = self else { return }
                    this.showAlert(message: "error: \(error.localizedDescription)")
                },
                onCompleted: { [weak self] in
                    guard let this = self else { return }
                    this.showAlert(message: "Saved!")
                })
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumViewController = segue.destination as? AlbumViewController else { return }
        albumViewController.selectedImage
            .subscribe(onNext: { [weak self] (newImage) in
                guard let this = self else { return }
                this.photo = newImage
                this.previewImageView.image = newImage
            })
            .disposed(by: disposeBag)
    }
}
