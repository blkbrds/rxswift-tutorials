//
//  Observable.swift
//  RxSwiftTutorials
//
//  Created by Dao Nguyen V. on 9/25/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

//------------------------------------------------------------
//    let dev = Developer()
//    dev.leader = Leader()
//    dev.start()
//------------------------------------------------------------

import RxSwift

let numbers = [1, 2, 3]
let numberStream = Observable.from(numbers)
