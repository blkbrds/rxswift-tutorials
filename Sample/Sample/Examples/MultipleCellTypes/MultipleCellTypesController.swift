//
//  MultipleCellTypesController.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/21/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MultipleCellTypesController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    /*
     Multiple cell types
     It’s nearly as easy to deal with multiple cell types. From a model standpoint, 
     the best way to handle it is to use an enum with associated data as the element model. 
     This way you can handle as many different cell types as you need while binding the table 
     to an observable of arrays of the enum type.
     */
    enum MyCellModel {
        case text(String)
        case photo(UIImage)
    }

    let observable: Observable<[MyCellModel]> = Observable.of([
            .text("text0"),
            .photo(#imageLiteral(resourceName: "image0")),
            .text("text1"),
            .photo(#imageLiteral(resourceName: "image1")),
            .text("text2"),
            .photo(#imageLiteral(resourceName: "image2")),
            .text("text3"),
            .photo(#imageLiteral(resourceName: "image3"))
    ])

    override func viewDidLoad() {
        super.viewDidLoad()

        // binding data

        observable.bind(to: collectionView.rx.items) { (collectionView: UICollectionView, index: Int, element: MyCellModel) in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .text(let title):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell", for: indexPath)
                if let cell = cell as? TextCollectionViewCell {
                    cell.titleLabel.text = title
                }
                return cell
            case .photo(let image):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath)
                if let cell = cell as? PhotoCollectionViewCell {
                    cell.photoImageView.image = image
                }
                return cell
            }
        }.disposed(by: disposeBag)

        // handle item click
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let this = self else { return }
                this.showAlert(message: "select item \(indexPath.row)")
            })
            .addDisposableTo(disposeBag)
    }
}
