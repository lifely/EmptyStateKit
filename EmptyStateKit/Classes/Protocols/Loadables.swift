//
//  Loadable.swift
//  WitbeMobileFoundation
//
//  Created by Julien Di Marco on 21/12/2020.
//

import UIKit
import Foundation

// -

public protocol Identifierable {

  static var identifier: String { get }

}

public extension Identifierable {

  static var identifier: String { return String(describing: self) }

}

// -

public protocol StoryboardLoadable: AnyObject {

  static var storyboardName: String { get }

}

public extension StoryboardLoadable where Self: UIViewController {

  // MARK: - Computed Properties

  static var instance: Self {
    return loadStoryboardController()
  }

  static var initialInstance: Self {
    return loadStoryboardInitialController()
  }

  // MARK: - Type Erasure

  static func loadStoryboardInitialController(name: String? = nil) -> Self {
    return loadStoryboardInitialControllerHelper(name: name, type: self)
  }

  static func loadStoryboardController(name: String? = nil, identifier: String? = nil) -> Self {
    return loadStoryboardControllerHelper(name: name, identifier: identifier, type: self)
  }

  // MARK: - Logics Helpers

  static func loadStoryboardHelper(name: String? = nil, bundle: Bundle? = nil, type: AnyClass) -> UIStoryboard {
    let name_ = name ?? storyboardName
    let bundle_ = bundle ?? Bundle(for: type)
    return UIStoryboard(name: name_, bundle: bundle_)
  }

  static func loadStoryboardInitialControllerHelper<T: UIViewController>(name: String? = nil,
                                                                         bundle: Bundle? = nil,
                                                                         type: T.Type) -> T {
    let name_ = name ?? storyboardName
    let storyboard = loadStoryboardHelper(name: name, bundle: bundle, type: type)
    guard let controller = storyboard.instantiateInitialViewController() as? T else {
      fatalError("UIViewController 'loadStoryboardInitialControllerHelper' w/ "
                  + "storyboardName: \(name_), bundle: \(bundle ?? Bundle.main) of \(type)")
    }

    return controller
  }

  static func loadStoryboardControllerHelper<T: UIViewController>(name: String? = nil,
                                                                  identifier: String? = nil,
                                                                  type: T.Type) -> T {
    _ = name ?? storyboardName
    let identifier_ = identifier ?? type.identifier
    let storyboard = loadStoryboardHelper(name: name, type: type)
    guard let controller = storyboard.instantiateViewController(withIdentifier: identifier_) as? T else {
      fatalError("UIViewController 'loadStoryboardInitialControllerHelper' w/ "
                  + "identifier: \(identifier_), w/ type: \(type), storyboardName: \(name ?? "")")
    }

    return controller
  }

}

// -

public protocol NibLoadable {

  static var nibName: String { get }

}

public extension NibLoadable where Self: Identifierable {

  static var nibName: String { return identifier }

}

public extension NibLoadable where Self: UIView {

  /// Load Nib from '.xib' files into an abstract `UIView` type, assign `outlet` to current instance
  /// This means you need to register `Outlets` on the `xib` `File Owner` for loading to work
  /// see. `MealNotificationView` for reference.
  func loadNibView(index: Int = 0, nibName: String? = nil) -> UIView {
    return Self.loadNibViewHelper(owner: self, type: UIView.self, index: index,
                                  nibName: nibName ?? Self.nibName, bundle: Bundle(for: type(of: self)))
  }

  /// Load Nib from '.xib' files into an genericaly typed `Self` which inherit `UIView`
  /// This means you need to register `Outlets` on the `xib` individual `view` you want to load
  /// this is probably what you want if you have a unique `xib` for multiple `views`
  /// see. `MessageOverlay` for reference,
  static func loadNibView(owner: Any? = nil, index: Int = 0, nibName: String? = nil, bundle: Bundle? = nil) -> Self {
    return loadNibViewHelper(owner: owner, type: self, index: index, nibName: nibName ?? self.nibName, bundle: bundle)
  }

  static func loadNibViewHelper<T: UIView>(owner: Any?, type: T.Type, index: Int? = nil,
                                                  nibName: String? = nil, bundle: Bundle? = nil) -> T {
    let bundle = bundle ?? Bundle(for: type)
    let nibName = nibName ?? type.nibName

    guard let loadedNibs = bundle.loadNibNamed(nibName, owner: owner, options: nil) else {
      fatalError("UIView - issue loading view from nib '\(nibName)' from bundle: \(bundle)")
    }

    return loadNibViewFilter(loadedNibs: loadedNibs, type: type, index: index, bundle: bundle)
  }

  static private func loadNibViewFilter<T: UIView>(loadedNibs: [Any], type: T.Type,
                                                   index: Int? = nil, bundle: Bundle) -> T {
    guard let index = index else {
      guard let loadedNibView = loadedNibs.first(where: { $0 is T }) as? T else {
        fatalError("UIView 'loadNibViewHelper' w/ '\(nibName)' of type (\(type)) for [\(bundle)]")
      }

      return loadedNibView
    }

    guard index < loadedNibs.count else {
      fatalError("UIView - issue loading view from '\(nibName)', (\(index)) index not available in loadedNibs")
    }

    guard let loadedNibView = loadedNibs[index] as? T else {
      fatalError("UIView 'loadNibViewHelper' w/ '\(nibName)' at (\(index)) for [\(bundle)]")
    }

    return loadedNibView
  }

}

public extension NibLoadable where Self: UIView {

  init(owner: AnyObject? = nil) {
    self = Self.loadNibViewHelper(owner: owner ?? Self.self, type: Self.self)
    return
  }

}

// -

public protocol Reusable {

  static var reuseIdentifier: String { get }

}

public extension Reusable where Self: Identifierable {

  static var reuseIdentifier: String { return identifier }

}

// -

public protocol ReusableViewKind {

  static var elementKind: String { get }

}

public extension ReusableViewKind {

  static var elementKind: String { return UICollectionView.elementKindSectionHeader }

}

// -

// MARK: - Conformance Definitions

extension UITableViewCell : Reusable {}
extension UITableViewHeaderFooterView: Reusable {}

//extension UICollectionViewCell:  Reusable {}
extension UICollectionReusableView: Reusable, ReusableViewKind {}

extension UIView: Identifierable, NibLoadable {}
extension UIViewController: Identifierable, NibLoadable { }
