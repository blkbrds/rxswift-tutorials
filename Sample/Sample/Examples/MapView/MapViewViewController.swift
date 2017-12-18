//
//  MapViewViewController.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/29/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxMapKit
import MapKit

class MapViewViewController: BaseViewController {

    let daNangCoor = CLLocationCoordinate2D(latitude: 16.047_515, longitude: 108.171_220_1)
    let hoiAnCoor = CLLocationCoordinate2D(latitude: 15.885_636_4, longitude: 108.306_090_6)

    @IBOutlet private weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservable()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addMapObjects()
    }

    private func setupObservable() {
        mapView.rx.handleViewForAnnotation { (mapView, annotation) in
            if let _ = annotation as? MKUserLocation {
                return nil
            } else if let anno = annotation as? Annotation {
                let view = mapView.dequeueReusableAnnotationView(withIdentifier: anno.reusableIdentifier) ??
                    MKAnnotationView(annotation: annotation, reuseIdentifier: anno.reusableIdentifier)
                view.image = #imageLiteral(resourceName: "marker_normal")
                view.canShowCallout = true
                view.isDraggable = true
                return view
            } else {
                return nil
            }
        }

        mapView.rx.didAddAnnotationViews
            .asDriver()
            .drive(onNext: { views in
                for view in views {
                    if let title = view.annotation?.title {
                        print("Did add annotation views: \(String(describing: title)) ")
                        view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                        UIView.animate(withDuration: 0.5, animations: {
                            view.transform = CGAffineTransform.identity
                        })
                    }
                }
            })
            .disposed(by: disposeBag)

        mapView.rx.didSelectAnnotationView
            .asDriver()
            .drive(onNext: { view in
                if let title = view.annotation?.title {
                    print("Did selected: \(String(describing: title))")
                    view.image = #imageLiteral(resourceName: "marker_selected")
                }
            })
            .disposed(by: disposeBag)

        mapView.rx.didDeselectAnnotationView
            .asDriver()
            .drive(onNext: { view in
                if let title = view.annotation?.title {
                    print("Did deselected: \(String(describing: title))")
                    view.image = #imageLiteral(resourceName: "marker_normal")
                }
            })
            .disposed(by: disposeBag)

        mapView.rx.regionDidChange
            .asDriver()
            .drive(onNext: {
                print("Did region change: \($0.region) isAnimated \($0.isAnimated)")
            })
            .disposed(by: disposeBag)

        mapView.rx.willStartLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Will start loading map")
            })
            .disposed(by: disposeBag)

        mapView.rx.didFinishLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Did finish loading map")
            })
            .disposed(by: disposeBag)

        mapView.rx.didFailLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Did fail loading map with error: \($0)")
            })
            .disposed(by: disposeBag)
    }

    private func addMapObjects() {
        mapView.addAnnotations([
            Annotation(coordinate: daNangCoor, title: "Here is Da Nang"),
            Annotation(coordinate: hoiAnCoor, title: "Here is Hoi An")
        ])

        // Move camera
        Observable.just(MKMapCamera(lookingAtCenter: daNangCoor, fromDistance: 200_000, pitch: 30, heading: 45))
            .bind(to: mapView.rx.cameraToAnimate)
            .disposed(by: disposeBag)
    }
}
