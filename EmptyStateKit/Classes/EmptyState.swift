//
//  EmptyState.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 23/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

// MARK: - Empty State - Delegates & Protocols

public protocol EmptyStateDelegate: AnyObject {

    func emptyState(emptyState: EmptyState, didPressButton button: UIButton)

}

public protocol EmptyStateDataSource: AnyObject {

    func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage?
    func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String?
    func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String?
    func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String?

}

// MARK: - Empty State - Definitions

public class EmptyStateContainer {

  public var _state: Any?
  public var _view: Any?

  public var emptyStateView: UIView? {
    get { return _view as? UIView }
    set { _view = newValue }
  }

  init<State: EmptyStateProtocol>(state: State) {
    self._state = state
    self._view = Self.view(for: state)
  }

// MARK: - builder

  /// Create empty state view
//  private static func view<State: EmptyStateProtocol, View: EmptyStateViewProtocol>(for state: State) -> View? {
//    guard let emptyStateView_: View = state.viewClass.init(owner: nil) as? View else { return nil }
//
//    emptyStateView_.configure(state)
//    emptyStateView_.isHidden = true
////    emptyStateView_.actionButton = { [weak self] (button) in
////        self?.didPressActionButton(button)
////    }
//
//    return emptyStateView_
//  }

  /// Create empty state view
  private static func view<State: EmptyStateProtocol>(for state: State) -> UIView? {
    let emptyStateView_ = state.view

//    emptyStateView_.isHidden = true

    return emptyStateView_
  }

}

public class EmptyState {

  // MARK: - Properties
    
    public weak var delegate: EmptyStateDelegate?
    public weak var dataSource: EmptyStateDataSource?

    public var format = EmptyStateFormat() {
        didSet {
//            emptyStateView?.format = format
        }
    }

  // MARK: - Private Properties

  public var container: EmptyStateContainer?

    private var tableView: UITableView?
    private var containerView: UIView?

    private var separatorStyle: UITableViewCell.SeparatorStyle = .none

    /// Show or hide view
    private var hidden = true {
        didSet {
//            emptyStateView?.isHidden = hidden
        }
    }
    
    /// State mode
    private var state: CustomState? {
        didSet {
            guard let _ = state, let viewModel = viewModel else { return }
//            emptyStateView?.model = viewModel
//            emptyStateView?.setNeedsLayout() ; emptyStateView?.layoutIfNeeded()
        }
    }


  // MARK: - Computed Properties

  private var viewModel: OriginalEmptyStateView.Model? {
    guard let state = state else { return nil }
//    guard let dataSource = dataSource else { return OriginalEmptyStateView.Model(state: state) }
//
//    return OriginalEmptyStateView.Model(state: state, dataSource: dataSource, container: self)
    return nil
  }

  // MARK: - Initializers

    init(inView view: UIView?) {
      self.containerView = view
    }

}

// MARK: - Builders

extension EmptyState {



  /// Add it to your view
  private func insertView(for emptyStateView: UIView, in view: UIView) -> UIView? {
    guard let view = containerView else { return nil }

    emptyStateView.translatesAutoresizingMaskIntoConstraints = false
    let bounds = CGSize(width: view.bounds.size.width,
                        height: UIView.layoutFittingCompressedSize.height)
    let size = emptyStateView.systemLayoutSizeFitting(bounds,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .defaultHigh)

    emptyStateView.frame = CGRect(origin: .zero, size: size)

    switch view {
      case let tableView as UITableView:
        tableView.tableFooterView = emptyStateView
        self.tableView = tableView
        separatorStyle = tableView.separatorStyle
      case let collectionView as UICollectionView:
        collectionView.backgroundView = emptyStateView
      case let stackView as UIStackView:
        stackView.addArrangedSubview(emptyStateView)
      default:
        emptyStateView.fixConstraintsInView(view)
    }

    return emptyStateView
  }

}

// MARK: - Presentations

extension EmptyState {
    
  public func show<State: EmptyStateProtocol>(_ state: State? = nil) {
//    self.state = state
    guard let containerView = containerView else { return }
    guard let state = state else { return } // viewModel needs to be removed

    container?.emptyStateView?.removeFromSuperview()
    container?.emptyStateView = nil

    container = EmptyStateContainer(state: state)

    guard let stateView = container?.emptyStateView else { return }
    container?.emptyStateView = insertView(for: stateView, in: containerView)

    hidden = false
    tableView?.separatorStyle = .none

//    emptyStateView?.play()
  }

  public func hide() {
    hidden = true
    tableView?.separatorStyle = separatorStyle

    container?.emptyStateView?.removeFromSuperview()
    container?.emptyStateView = nil
  }

}

// MARK: - Actions / Events

extension EmptyState {
    
    private func didPressActionButton(_ button: UIButton) {
        delegate?.emptyState(emptyState: self, didPressButton: button)
    }

}
