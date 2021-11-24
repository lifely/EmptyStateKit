//
//  EmptyStateProtocols.swift
//  EmptyStateKit
//
//  Created by Julien Di Marco on 23/11/2021.
//

import UIKit

// MARK: - State Protocol -

public protocol EmptyStateBase {

//  var model: EmptyStateModel { get }
//  var format: EmptyStateFormat { get }
//  var animation: EmptyStateAnimation { get }

//  var viewClass: EmptyStateViewBase.Type { get }

}

public protocol EmptyStateProtocol: EmptyStateBase {
  associatedtype Model: EmptyStateModel
  associatedtype View: EmptyStateViewProtocol

  var model: Model { get }
  var format: EmptyStateFormat { get }
  var animation: EmptyStateAnimation { get }

  var viewClass: View.Type { get }

}

public extension EmptyStateProtocol {

  var view: View {
//    guard let state = self as? Self.View.State else {
//      fatalError("EmptyState - state: \(self), unexpected for viewClass: \(viewClass), expecting: \(Self.View.State.self)")
//    }

    return viewClass.init(owner: nil).configure(self)
  }

}

// MARK: - State Model Protocol -

public protocol EmptyStateModel {

  var error: Swift.Error? { get }

  var image: UIImage? { get }

  var title: String? { get }
  var description: String? { get }

  var actionTitle: String? { get }
  var actionClosure: ((UIButton) -> ())? { get }

}

// MARK: - State View Protocol -

public protocol EmptyStateViewBase: UIView { }

public protocol EmptyStateViewProtocol: UIView, EmptyStateBase {
  associatedtype Model: EmptyStateModel
//  associatedtype State: EmptyStateProtocol

  // MARK: - Properties

  var model: Model { get set }
  var format: EmptyStateFormat { get set }
  var animation: EmptyStateAnimation { get set }

  // MARK: - configuration

  @discardableResult
  func configure<State: EmptyStateProtocol>(_ state: State) -> Self
//  func configure(_ state: State) -> Self

}

public extension EmptyStateViewProtocol {

  init<State: EmptyStateProtocol>(_ state: State) {
//  init(_ state: State) {
    self.init(owner: nil)
    configure(state)
  }

}
