//
//  Storyboard.swift
//  RxSwift
//
//  Created by Huynh Quang Tien on 6/5/17.
//  Copyright © 2017 Asian Tech. All rights reserved.
//

import UIKit

extension UIStoryboard {

    // MARK: - View Controller Instantiation from Generics

    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
