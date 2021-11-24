//
//  EmptyStateView+Animations.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 24/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

// MARK: - Fade Animation Protocol

public protocol FadeAnimationView {

  var imageView: UIImageView! { get }
  var actionButton: UIButton! { get }

  var titleLabel: UILabel! { get }
  var descriptionLabel: UILabel! { get }

}

// MARK: - Fade Animation

public struct FadeAnimation: EmptyStateAnimation {

  // MARK: - Properties

  public var duration1: FadeTimeInterval
  public var duration2: FadeTimeInterval

  // MARK: - Initializers

  public init(_ duration: FadeTimeInterval, _ duration2: FadeTimeInterval) {
    self.duration1 = duration
    self.duration2 = duration2
  }
  // MARK: -

  public func animate(_ view: UIView) {
    guard let view = view as? FadeAnimationView else { return }

    view.imageView?.alpha = 0
    view.titleLabel?.alpha = 0
    view.descriptionLabel?.alpha = 0
    view.actionButton?.alpha = 0

    UIView.animate(withDuration: duration1, animations: {
      view.titleLabel?.alpha = 1
      view.descriptionLabel?.alpha = 1
      view.actionButton?.alpha = 1
    }) { (completed) in
      UIView.animate(withDuration: duration2, animations: {
        view.imageView?.alpha = 1
      }, completion: nil)
    }
  }

}

// MARK: - Scale Animation Protocol

public protocol ScaleAnimationView: FadeAnimationView { }

// MARK: - Scale Animation

public struct ScaleAnimation: EmptyStateAnimation {

  // MARK: - Properties

  public var fadeDuration: FadeTimeInterval
  public var scaleDuration: FadeTimeInterval

  // MARK: - Initializers

  public init(fadeDuration: FadeTimeInterval, scaleDuration: FadeTimeInterval) {
    self.fadeDuration = fadeDuration
    self.scaleDuration = scaleDuration
  }

  // MARK: -

  public func animate(_ view: UIView) {
    guard let view = view as? ScaleAnimationView else { return }

    view.titleLabel?.alpha = 0
    view.descriptionLabel?.alpha = 0

    view.actionButton?.alpha = 0
    view.imageView?.transform = CGAffineTransform(scaleX: 0, y: 0)

    UIView.animate(withDuration: fadeDuration, animations: {
      view.titleLabel?.alpha = 1
      view.descriptionLabel?.alpha = 1
      view.actionButton?.alpha = 1
    }) { (completed) in
      UIView.animate(withDuration: scaleDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
        view.imageView?.transform = .identity
      }, completion: nil)
    }
  }

}

// Animations
//extension OriginalEmptyStateView {
//
//    // Fade animation
//    func fade(_ duration1: TimeInterval, _ duration2: TimeInterval) {
//
//        imageView.alpha = 0
//        titleLabel.alpha = 0
//        descriptionLabel.alpha = 0
//        primaryButton.alpha = 0
//
//        UIView.animate(withDuration: duration1, animations: { [weak self] in
//            self?.titleLabel.alpha = 1
//            self?.descriptionLabel.alpha = 1
//            self?.primaryButton.alpha = 1
//        }) { [weak self](completed) in
//            UIView.animate(withDuration: duration2, animations: { [weak self] in
//                self?.imageView.alpha = 1
//            }, completion: nil)
//        }
//    }
//
//    // Scale animation
//    func scale(_ duration1: TimeInterval, _ duration2: TimeInterval) {
//
//        imageView.transform = CGAffineTransform(scaleX: 0, y: 0)
//        titleLabel.alpha = 0
//        descriptionLabel.alpha = 0
//        primaryButton.alpha = 0
//
//        UIView.animate(withDuration: duration1, animations: { [weak self] in
//            self?.titleLabel.alpha = 1
//            self?.descriptionLabel.alpha = 1
//            self?.primaryButton.alpha = 1
//        }) { [weak self](completed) in
//            UIView.animate(withDuration: duration2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: { [weak self] in
//                self?.imageView.transform = .identity
//            }, completion: nil)
//        }
//    }
//}
