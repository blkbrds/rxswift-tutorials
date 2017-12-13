//
//  AlbumViewController.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/23/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import Photos
import RxSwift

class AlbumViewController: UICollectionViewController {

    let bag = DisposeBag()
    var selectedImage: Observable<UIImage> {
        return selectedImageSubject.asObservable()
    }

    fileprivate let selectedImageSubject = PublishSubject<UIImage>()
    fileprivate lazy var images = AlbumViewController.loadImages()
    fileprivate lazy var imageManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AlbumViewController {
    static func loadImages() -> PHFetchResult<PHAsset> {
        let allImagesOptions = PHFetchOptions()
        allImagesOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allImagesOptions)
    }
}

extension AlbumViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let asset = images.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            cell.layer.contents = image?.cgImage
        })
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let asset = images.object(at: indexPath.item)

        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                cell.alpha = 1
            })
        }

        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
            guard let image = image, let info = info else { return }

            if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool, !isThumbnail {
                guard let this = self else { return }
                this.selectedImageSubject.onNext(image)
                this.dismiss(animated: true, completion: nil)
            }
        })
    }
}
