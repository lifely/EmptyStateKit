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

public class EmptyState {

  // MARK: - Properties
    
    public weak var delegate: EmptyStateDelegate?
    public weak var dataSource: EmptyStateDataSource?

    public var format = EmptyStateFormat() {
        didSet {
            emptyStateView?.format = format
        }
    }

  // MARK: - Private Properties

    private var tableView: UITableView?
    private var containerView: UIView?

    private var emptyStateView: EmptyStateView?
    private var separatorStyle: UITableViewCell.SeparatorStyle = .none
    
    /// Show or hide view
    private var hidden = true {
        didSet {
            emptyStateView?.isHidden = hidden
        }
    }
    
    /// State mode
    private var state: CustomState? {
        didSet {
            guard let _ = state, let viewModel = viewModel else { return }
            emptyStateView?.viewModel = viewModel
//            emptyStateView?.setNeedsLayout() ; emptyStateView?.layoutIfNeeded()
        }
    }


  // MARK: - Computed Properties

  private var viewModel: EmptyStateView.ViewModel? {
    guard let state = state else { return nil }
    guard let dataSource = dataSource else {  return EmptyStateView.ViewModel(state: state) }

    return EmptyStateView.ViewModel(state: state, dataSource: dataSource, container: self)
  }

  // MARK: - Initializers

    init(inView view: UIView?) {
      self.containerView = view
    }

}

// MARK: - Builders

extension EmptyState {

  /// Create empty state view
  private func view(for state: CustomState, model: EmptyStateView.ViewModel) -> EmptyStateView? {
    guard let emptyStateView_: EmptyStateView = state.viewClass.view as? EmptyStateView else { return nil }

    emptyStateView_.format = format
    emptyStateView_.viewModel = model
    emptyStateView_.isHidden = true
    emptyStateView_.actionButton = { [weak self] (button) in
        self?.didPressActionButton(button)
    }

    return emptyStateView_
  }

  /// Add it to your view
  private func insertView(for emptyStateView: EmptyStateView, in view: UIView) -> EmptyStateView? {
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
    
  public func show(_ state: CustomState? = nil) {
    self.state = state
    guard let containerView = containerView else { return }
    guard let state = state, let model = self.viewModel else { return }

    emptyStateView?.removeFromSuperview()
    emptyStateView = nil

    guard let stateView = view(for: state, model: model) else { return }
    emptyStateView = insertView(for: stateView, in: containerView)

    hidden = false
    tableView?.separatorStyle = .none

    emptyStateView?.play()
  }

  public func hide() {
    hidden = true
    tableView?.separatorStyle = separatorStyle

    emptyStateView?.removeFromSuperview()
    emptyStateView = nil
  }

}

// MARK: - Actions / Events

extension EmptyState {
    
    private func didPressActionButton(_ button: UIButton) {
        delegate?.emptyState(emptyState: self, didPressButton: button)
    }

}
