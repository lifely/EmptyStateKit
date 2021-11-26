//
//  SimpleEmptyStateView.swift
//  EmptyStateKit
//
//  Created by Julien Di Marco on 23/11/2021.
//

import Foundation

//extension SimpleEmptyStateView: EmptyStateViewProtocol {}

public class SimpleEmptyStateView: UIView, EmptyStateViewProtocol {
  public typealias State = SimpleEmptyState

  // MARK: - Interfaces Properties

  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var containerView: UIView?

  @IBOutlet public weak var imageView: UIImageView!
  @IBOutlet public weak var actionButton: UIButton!

  @IBOutlet public weak var titleLabel: UILabel!
  @IBOutlet public weak var descriptionLabel: UILabel!

  // MARK: - Constraints Properties

  @IBOutlet var containerTopConstraint: NSLayoutConstraint?
  @IBOutlet var containerBottomConstraint: NSLayoutConstraint?
  @IBOutlet var containerLeadingConstraint: NSLayoutConstraint?
  @IBOutlet var containerTraillingonstraint: NSLayoutConstraint?

  // MAKR: - Properties

  public var model = Model() {
    didSet { fillView() }
  }

  public var format = EmptyStateFormat() {
    didSet { updateUI() ; fillView() }
  }

  public var animation: EmptyStateAnimation = DefaultEmptyStateAnimation.none

  public var delegateActionClosure: DelegateAction?

  // MARK: - Private Properties

  private var gradientLayer: CAGradientLayer?

  // MARK: - Initializers

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  public convenience init(state: SimpleEmptyState) {
    self.init(owner: nil)
    configure(state)
  }

  // MARK: - UIView (life-cycle)

  override public func awakeFromNib() {
    super.awakeFromNib()

    setupView()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    actionButton?.layer.cornerRadius = 20
    titleLabel.setNeedsLayout() ; titleLabel.layoutSubviews()
    descriptionLabel.setNeedsLayout() ; descriptionLabel.layoutSubviews()
  }

  // MARK: - Configuration -

  @discardableResult
  public func configure<State: EmptyStateProtocol>(_ state: State) -> Self {
    if let model = state.model as? SimpleEmptyState.Model { self.model = model }
    self.format = state.format
    self.animation = state.animation
    return self
  }

  // MARK: - Actions / Events

  public func play() {
    //animation.play?(self)
  }

  @IBAction private func didPressPrimaryButton(_ sender: UIButton) {
    let action = model.actionClosure ?? delegateActionClosure
    action?(sender)
  }

}

// MARK: - UIView - Configuration -

extension SimpleEmptyStateView {

  private func setupView() { }

  private func fillView() {
    if case .cover(_, _) = format.position.image {
      imageView?.image = nil
    } else {
      imageView?.image = model.image
    }

    if let title = model.title {
      titleLabel?.isHidden = false
      titleLabel?.attributedText = NSAttributedString(string: title, attributes: format.titleAttributes)
    } else {
      titleLabel?.isHidden = true
    }

    if let description = model.description {
      descriptionLabel?.isHidden = false
      descriptionLabel?.attributedText = NSAttributedString(string: description, attributes: format.descriptionAttributes)
    } else {
      descriptionLabel?.isHidden = true
    }

    if let titleButton = model.actionTitle {
      actionButton?.isHidden = false
      actionButton?.setAttributedTitle(NSAttributedString(string: titleButton, attributes: format.buttonAttributes), for: .normal)
    } else {
      actionButton?.isHidden = true
    }

    if model.image == nil { imageView?.isHidden = true }
  }

  private func updateUI() {
    containerView?.backgroundColor = format.containerBackgroundColor

    containerTopConstraint?.constant = format.contentEdgetInset.top
    containerBottomConstraint?.constant = format.contentEdgetInset.bottom
    containerLeadingConstraint?.constant = format.contentEdgetInset.left
    containerTraillingonstraint?.constant = format.contentEdgetInset.right

    if let cornerRadius = format.containerCornerRadius {
      containerView?.clipsToBounds = true
      containerView?.layer.cornerRadius = cornerRadius
    }

    imageView?.isHidden = false
    imageView?.tintColor = format.imageTintColor ?? .systemBlue

    // Primary button format
    actionButton?.backgroundColor = format.buttonColor
    actionButton?.layer.cornerRadius = format.buttonRadius
    actionButton?.layer.shadowColor = format.buttonColor.cgColor
    actionButton?.layer.shadowOffset = CGSize(width: 0.0, height: 0)
    actionButton?.layer.masksToBounds = false
    actionButton?.layer.shadowRadius = format.buttonShadowRadius
    actionButton?.layer.shadowOpacity = 0.5

    // Message format
    messageView.alpha = format.alpha

    // Background format
    backgroundColor = format.backgroundColor

    // Background gradient format
    if let gradientColor = format.gradientColor {
      gradientLayer?.removeFromSuperlayer()
      gradientLayer = CAGradientLayer()
      gradientLayer?.colors = [gradientColor.0.cgColor, gradientColor.1.cgColor]
      gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
      gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0.0)
      gradientLayer?.locations = [0, 1]
      gradientLayer?.frame = bounds
      layer.insertSublayer(gradientLayer!, at: 0)
    } else {
      gradientLayer?.removeFromSuperlayer()
    }
  }

}

// MARK: - Simple EmptyState View - Model

public extension SimpleEmptyStateView {

  struct Model: EmptyStateModel {

    public var error: Error?

    public var title: String?
    public var description: String?

    public var image: UIImage?

    public var actionTitle: String?
    public var actionClosure: DelegateAction?

    public init(error: Error? = nil, title: String? = nil, description: String? = nil, image: UIImage? = nil,
                actionTitle: String? = nil, actionClosure: DelegateAction? = nil) {
      self.error = error
      self.title = title
      self.description = description
      self.image = image
      self.actionTitle = actionTitle
      self.actionClosure = actionClosure
    }

  }

}

// MARK: - Animation Comformances

extension SimpleEmptyStateView: FadeAnimationView { }
extension SimpleEmptyStateView: ScaleAnimationView { }
