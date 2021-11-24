//
//  OriginalEmptyState.swift
//  EmptyStateKit
//
//  Created by Julien Di Marco on 23/11/2021.
//

import Foundation

public struct OriginalEmptyState: EmptyStateProtocol {

  // MARK: - Properties

  public var format: EmptyStateFormat = EmptyStateFormat()
  public var animation: EmptyStateAnimation = EmptyStateAnimation.none
  public var viewClass: OriginalEmptyStateView.Type = OriginalEmptyStateView.self

  public var model: OriginalEmptyStateView.Model = {
    return Model(title: "Test", description: "Test", actionTitle: "Test")
  }()

  // MARK: - Initializers

  public init () { }

}
