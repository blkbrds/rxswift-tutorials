//
//  CarListViewModel.swift
//  RxSwift-Demo
//
//  Created by Huynh Quang Tien on 6/8/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import Foundation
import MVVM
import RxSwift

class CarListViewModel: ViewModel {
    // `Variable` wraps a Subject. More specifically it is a BehaviorSubject. Unlike BehaviorSubject, it only exposes value interface, so variable can never terminate or fail.
    private let cars: Variable<[Car]> = {
        let ferrariF12 = Car(model: "F12", make: "Ferrari", kilowatts: 544, photoURL: "http://auto.ferrari.com/en_EN/wp-content/uploads/sites/5/2013/07/Ferrari-F12berlinetta.jpg")
        let zondaF = Car(model: "Zonda F", make: "Pagani", kilowatts: 449, photoURL: "http://storage.pagani.com/view/1024/BIG_zg-4-def.jpg")
        let lamboAventador = Car(model: "Aventador", make: "Lamborghini", kilowatts: 522, photoURL: "http://cdn.lamborghini.com/content/models/aventador_lp700-4_roadster/gallery_2013/roadster_21.jpg")

        return Variable([ferrariF12, zondaF, lamboAventador])
    }()

    var dataObservable: Observable<[Car]> {
        return cars.asObservable()
    }

    func viewModelForItem(at indexPath: IndexPath) -> CarViewModel? {
        guard indexPath.row >= 0 && indexPath.row < cars.value.count else { return nil }
        return CarViewModel(car: cars.value[indexPath.row])
    }
}
