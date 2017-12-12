//
//  Annotation.swift
//  RxSwift-Demo
//
//  Created by Hieu Tran T. on 6/29/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import MapKit

class Annotation: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    let reusableIdentifier: String = "annotaion"

    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
