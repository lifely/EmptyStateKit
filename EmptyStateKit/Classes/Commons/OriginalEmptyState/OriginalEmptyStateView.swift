//
//  EmptyStateView.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 23/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

public class OriginalEmptyStateView: UIView, EmptyStateViewProtocol {

  // MARK: - Interfaces Properties

  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var containerView: UIView?

  @IBOutlet public weak var imageView: UIImageView!
  @IBOutlet public weak var coverImageView: UIImageView?

  @IBOutlet public weak var titleLabel: UILabel!
  @IBOutlet public weak var descriptionLabel: UILabel!

  @IBOutlet public weak var actionButton: UIButton!
    
  // MARK: - Constraints Properties

  @IBOutlet var primaryButtonWidthConstraint: NSLayoutConstraint?
  @IBOutlet var messageViewCenterYConstraint: NSLayoutConstraint?
  @IBOutlet var messageViewBottomConstraint: NSLayoutConstraint?
  @IBOutlet var messageViewTopConstraint: NSLayoutConstraint?
  @IBOutlet var messageViewLeftConstraint: NSLayoutConstraint?
  @IBOutlet var messageViewRightConstraint: NSLayoutConstraint?
  @IBOutlet var primaryButtonCenterXConstraint: NSLayoutConstraint?
  @IBOutlet var primaryButtonLeftConstraint: NSLayoutConstraint?
  @IBOutlet var primaryButtonRightConstraint: NSLayoutConstraint?
  @IBOutlet var primaryButtonTopConstraint: NSLayoutConstraint?
  @IBOutlet var primaryButtonTop2Constraint: NSLayoutConstraint?
  @IBOutlet var imageViewTopConstraint: NSLayoutConstraint?
  @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint?
  @IBOutlet var imageViewTop2Constraint: NSLayoutConstraint?
  @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint?
  @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint?
  @IBOutlet var titleLabelTopConstraint: NSLayoutConstraint?
  @IBOutlet weak var coverImageViewTopConstraint: NSLayoutConstraint?
  @IBOutlet weak var coverImageViewBottomConstraint: NSLayoutConstraint?

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

  // MARK: - UIView (life-cycle)

  override public func awakeFromNib() {
    super.awakeFromNib()

    setupView()
    actionButton.layer.cornerRadius = 20
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    updateUI()
  }

  // MARK: - Initializers

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  public convenience init(state: OriginalEmptyState) {
    self.init(owner: nil)
    configure(state)
  }

  // MARK: - Configuration -

  @discardableResult
  public func configure(_ state: OriginalEmptyState) -> Self {
    self.model = state.model
    self.format = state.format
    self.animation = state.animation
    return self
  }

  @discardableResult
  public func configure<State: EmptyStateProtocol>(_ state: State) -> Self {
    if let model = state.model as? OriginalEmptyStateView.Model { self.model = model }
    self.format = state.format
    self.animation = state.animation
    return self
  }

  // MARK: - Actions / Events

  func play() {
    animation.animate(self)
  }

  @IBAction func didPressPrimaryButton(_ sender: UIButton) {
    let action = model.actionClosure ?? delegateActionClosure
    action?(sender)
  }
    
}

extension OriginalEmptyStateView {
    
    private func setupView() {
        
    }
    
    private func fillView() {
        
        if case .cover(_, _) = format.position.image {
            coverImageView?.image = model.image
            imageView.image = nil
        } else {
            coverImageView?.image = nil
            imageView.image = model.image
        }
        
        if let title = model.title {
            titleLabel.isHidden = false
            titleLabel.attributedText = NSAttributedString(string: title, attributes: format.titleAttributes)
        } else {
            titleLabel.isHidden = true
        }
        
        if let description = model.description {
            descriptionLabel.isHidden = false
            descriptionLabel.attributedText = NSAttributedString(string: description, attributes: format.descriptionAttributes)
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let titleButton = model.actionTitle {
          actionButton.isHidden = false
          actionButton.setAttributedTitle(NSAttributedString(string: titleButton, attributes: format.buttonAttributes), for: .normal)
        } else {
          actionButton.isHidden = true
        }

      if model.image == nil { imageView.isHidden = true }
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

        imageView.isHidden = false
        coverImageView?.isHidden = true

        if let imageTintColor = format.imageTintColor {
            imageView.tintColor = imageTintColor
            coverImageView?.tintColor = imageTintColor
        } else {
            imageView.tintColor = .systemBlue
            coverImageView?.tintColor = .systemBlue
        }
        
        // Primary button format
      actionButton.backgroundColor = format.buttonColor
      actionButton.layer.cornerRadius = format.buttonRadius
      actionButton.layer.shadowColor = format.buttonColor.cgColor
      actionButton.layer.shadowOffset = CGSize(width: 0.0, height: 0)
      actionButton.layer.masksToBounds = false
      actionButton.layer.shadowRadius = format.buttonShadowRadius
      actionButton.layer.shadowOpacity = 0.5
        
        if let buttonWidth = format.buttonWidth {
            primaryButtonWidthConstraint?.isActive = true
            primaryButtonWidthConstraint?.constant = buttonWidth
        } else {
            primaryButtonWidthConstraint?.isActive = false
        }
        
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
        
        // Setup constraints
        imageViewWidthConstraint?.constant = format.imageSize.width
        imageViewHeightConstraint?.constant = format.imageSize.height
        
        setupViewPosition(format.position.view)
        setupTextPosition(format.position.text)
        setupImagePosition(format.position.image)
        setupLateralPosition()
    }
    
}

//extension EmptyStateView: NibLoadable {}

// MARK: - Original EmptyState View - Model

public extension OriginalEmptyStateView {

  struct Model: EmptyStateModel {

    public var error: Error?

    public var title: String?
    public var description: String?

    public var image: UIImage?
    public var coverImage: UIImage?

    public var actionTitle: String?
    public var actionClosure: DelegateAction?

    public init(error: Error? = nil, title: String? = nil, description: String? = nil,
                image: UIImage? = nil, coverImage: UIImage? = nil,
                actionTitle: String? = nil, actionClosure: DelegateAction? = nil) {
      self.error = error
      self.title = title
      self.description = description
      self.image = image
      self.coverImage = coverImage
      self.actionTitle = actionTitle
      self.actionClosure = actionClosure
    }

  }

}

extension OriginalEmptyStateView.Model {

  init(state: CustomState) {
    self.init(error: nil, title: state.title, description: state.description, image: state.image,
              actionTitle: state.titleButton)
  }

  init(state: CustomState, dataSource: EmptyStateDataSource, container: EmptyState) {
    self.init(error: nil, title: dataSource.titleForState(state, inEmptyState: container),
              description: dataSource.descriptionForState(state, inEmptyState: container),
              image: dataSource.imageForState(state, inEmptyState: container),
              actionTitle: dataSource.titleButtonForState(state, inEmptyState: container))
  }

}


// MARK: - Animation Comformances

extension OriginalEmptyStateView: FadeAnimationView { }
extension OriginalEmptyStateView: ScaleAnimationView { }
