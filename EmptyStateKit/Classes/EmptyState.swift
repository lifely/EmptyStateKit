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

  func emptyState(emptyState: EmptyState, didPressButton button: UIButton, state: Any?)

}

public protocol EmptyStateDataSource: AnyObject {

    func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage?
    func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String?
    func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String?
    func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String?

}

// MARK: - Empty State - Definitions

public class EmptyStateContainer {

  // MARK: - Properties

  public var _state: Any?
  public var _view: Any?

 // MARK: - Computed Properties

  public var emptyStateView: UIView? {
    get { return _view as? UIView }
    set { _view = newValue }
  }

  // MARK: - Initializer

  init<State: EmptyStateProtocol>(state: State) {
    self._state = state
    self._view = Self.view(for: state)
  }

  // MARK: - Type Erasure

  public func animate<State: EmptyStateProtocol>(for state: State) {
    guard let view = emptyStateView as? State.View else { return }
    view.animation.animate(view)
  }

  public func actionDelegate<State: EmptyStateProtocol>(_ action: DelegateAction?, for state: State) {
    guard let view = emptyStateView as? State.View else { return }
    view.delegateActionClosure = action
  }

  public func view<State: EmptyStateProtocol, View: EmptyStateViewProtocol>(for state: State) -> View? where State.View == View {
    guard let view = emptyStateView as? State.View else { return nil }
    return view
  }

// MARK: - builder

  /// Create empty state view
  private static func view<State: EmptyStateProtocol>(for state: State) -> UIView? {
    let emptyStateView_ = state.view
    emptyStateView_.isHidden = true
    return emptyStateView_
  }

  // MARK: - Memory

  deinit {
    emptyStateView?.removeFromSuperview()
    emptyStateView = nil
  }

}

public class EmptyState {

  // MARK: - Properties

  public var container: EmptyStateContainer?

  public weak var delegate: EmptyStateDelegate?
  public weak var dataSource: EmptyStateDataSource?

  // MARK: - Private Properties

  private var state: Any?

  private weak var tableView: UITableView?
  private weak var collectionView: UICollectionView?
  private var separatorStyle: UITableViewCell.SeparatorStyle = .none

  private weak var containerView: UIView?
  private var backgroundContainerView: UIView?

  // MARK: - Computed Properties

  public var format: EmptyStateFormat? = nil

  /// Show or hide view
  private var hidden: Bool {
    get { return container?.emptyStateView?.isHidden ?? true }
    set { container?.emptyStateView?.isHidden = newValue }
  }

  // MARK: - Initializers

  init(inView view: UIView?) {
    self.containerView = view
  }

  public func prepareTableCollectionViews() {
    guard let containerView = containerView else { return }

    switch containerView {
      case let tableView as UITableView:
        self.tableView = tableView
        self.separatorStyle = tableView.separatorStyle
        self.backgroundContainerView = UIView(frame: CGRect(origin: .zero, size: tableView.bounds.size))
        tableView.backgroundView = backgroundContainerView

      case let collectionView as UICollectionView:
        self.collectionView = collectionView
        self.backgroundContainerView = UIView(frame: CGRect(origin: .zero, size: collectionView.bounds.size))
        collectionView.backgroundView = backgroundContainerView

      default: break
    }

    backgroundContainerView?.isHidden = true
  }

  public func layoutEmptyStateView() {
    guard let container = container, let view = container.emptyStateView else { return }

    view.setNeedsLayout() ; view.layoutSubviews()
  }

  // MARK: - Memory

  deinit {
    clear()
  }

}

// MARK: - Builders

extension EmptyState {

  private func layoutView(for emptyStateView: UIView, in view: UIView) -> UIView {
    emptyStateView.translatesAutoresizingMaskIntoConstraints = false

    let bounds = CGSize(width: view.bounds.size.width,
                        height: UIView.layoutFittingCompressedSize.height)

    let size = emptyStateView.systemLayoutSizeFitting(bounds,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .defaultLow)

    emptyStateView.frame = CGRect(origin: .zero, size: size)

    return emptyStateView
  }

  /// Add it to your view
  private func insertView(for emptyStateView: UIView, in view: UIView) -> UIView? {
    guard let view = containerView else { return nil }
    let emptyStateView = layoutView(for: emptyStateView, in: view)

    switch view {
      // MARK: - CollectionView Prepared
      case let tableView as UITableView where backgroundContainerView != nil:
        self.tableView = tableView
        self.separatorStyle = tableView.separatorStyle

        backgroundContainerView?.subviews.forEach({ $0.removeFromSuperview() })
        backgroundContainerView?.isHidden = false
        emptyStateView.fixConstraintsInView(backgroundContainerView)
        tableView.invalidateIntrinsicContentSize()

      case is UICollectionView where backgroundContainerView != nil:
        backgroundContainerView?.subviews.forEach({ $0.removeFromSuperview() })
        backgroundContainerView?.isHidden = false
        emptyStateView.fixConstraintsInView(backgroundContainerView)
        collectionView?.invalidateIntrinsicContentSize()

      // MARK: - Collection View Not Prepared

      case let tableView as UITableView:
        tableView.superview?.insertSubview(emptyStateView, aboveSubview: tableView)
        emptyStateView.fixConstraintsInView(view, insert: false)

      case let collectionView as UICollectionView:
        collectionView.superview?.insertSubview(emptyStateView, aboveSubview: collectionView)
        emptyStateView.fixConstraintsInView(view, insert: false)

      case let stackView as UIStackView:
        stackView.addArrangedSubview(emptyStateView)
      default:
        emptyStateView.fixConstraintsInView(view)
    }

    if let backgroundCountainer = backgroundContainerView {
      backgroundContainerView?.frame = CGRect(origin: .zero, size: backgroundCountainer.bounds.size)
    }

    emptyStateView.setNeedsLayout()
    emptyStateView.layoutIfNeeded()

    return emptyStateView
  }

}

// MARK: - Presentations

extension EmptyState {
    
  public func show<State: EmptyStateProtocol>(_ state: State? = nil) {
    self.state = state
    guard let containerView = containerView else { return }
    guard let state = state else { return } // viewModel needs to be removed

    container = EmptyStateContainer(state: state)

    if let format = format { container?.view(for: state)?.format = format }
    container?.actionDelegate({ [weak self] (button) in
      self?.didPressActionButton(button)
    }, for: state)

    guard let stateView = container?.emptyStateView else { return }
    container?.emptyStateView = insertView(for: stateView, in: containerView)

    hidden = false
    tableView?.separatorStyle = .none

    container?.animate(for: state)
  }

  public func hide() {
    state = nil
    hidden = true
    tableView?.separatorStyle = separatorStyle

    backgroundContainerView?.isHidden = true
    backgroundContainerView?.subviews.forEach({ $0.removeFromSuperview() })
    backgroundContainerView?.removeFromSuperview()

    container = nil
  }

  public func clear() {
    state = nil
    hidden = true
    tableView?.separatorStyle = separatorStyle

    backgroundContainerView?.isHidden = true
    backgroundContainerView?.subviews.forEach({ $0.removeFromSuperview() })
    backgroundContainerView?.removeFromSuperview()

    container = nil
  }

}

// MARK: - Actions / Events

extension EmptyState {
    
  private func didPressActionButton(_ button: UIButton) {
    delegate?.emptyState(emptyState: self, didPressButton: button, state: state)
  }

}
