//
//  State.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 23/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit



public protocol CustomState {

  // MARK: - Properties

    var image: UIImage? { get }
    var title: String? { get }
    var description: String? { get }
    var titleButton: String? { get }

    var viewClass: UIView.Type { get }

}

public extension CustomState {
    
    var image: UIImage? {
        get { return nil }
    }
    
    var title: String? {
        get { return nil }
    }
    
    var description: String? {
        get { return nil }
    }
    
    var titleButton: String? {
        get { return nil }
    }

    var viewClass: UIView.Type {
      return OriginalEmptyStateView.self
    }

}
