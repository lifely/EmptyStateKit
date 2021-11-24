//
//  SimpleEmptyState.swift
//  EmptyStateKit
//
//  Created by Julien Di Marco on 23/11/2021.
//

import Foundation

//public struct SimpleEmptyState: EmptyStateProtocol {
//
//  public var model: SimpleEmptyStateView.Model {
//    return Model(error: nil, title: "Test", description: "Test", image: nil, actionTitle: "Test", actionClosure: nil)
//  }
//
//  public var format: EmptyStateFormat { return EmptyStateFormat() }
//
//  public var animation: EmptyStateAnimation = DefaultEmptyStateAnimation.none
//
//  public var viewClass: SimpleEmptyStateView.Type = SimpleEmptyStateView.self
//
//  public init () { }
//
//}

public enum SimpleEmptyState: EmptyStateProtocol {

  case noBox
  case noCart

  // MARK: - Properties

  public var model: SimpleEmptyStateView.Model {
    switch self {
      case .noBox: return Model(error: nil, title: "noBox", description: "Test", actionTitle: "Test")
      case .noCart: return Model(error: nil, title: "noCart", description: "Test", actionTitle: "Test")
    }
  }

  public var format: EmptyStateFormat { return EmptyStateFormat() }

  public var animation: EmptyStateAnimation { return DefaultEmptyStateAnimation.none }

  public var viewClass: SimpleEmptyStateView.Type { return SimpleEmptyStateView.self }

}
