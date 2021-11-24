//
//  MainState.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 28/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit

enum MainState: EmptyStateProtocol {

    case noInternet

  public var model: OriginalEmptyStateView.Model {
    return  OriginalEmptyStateView.Model(error: nil, title: "We’re Sorry",
                                         description: "Our staff is still working on the issue for better experience",
                                         image: UIImage(named: "Internet"),
                                         actionTitle: "Try again?")
  }

  public var format: EmptyStateFormat {
    var format = EmptyStateFormat()
    format.buttonColor = "44CCD6".hexColor
    format.position = EmptyStatePosition(view: .bottom, text: .left, image: .top)
    format.verticalMargin = 40
    format.horizontalMargin = 40
    format.imageSize = CGSize(width: 320, height: 200)
    format.buttonShadowRadius = 10
    format.titleAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 26)!, .foregroundColor: UIColor.white]
    format.descriptionAttributes = [.font: UIFont(name: "Avenir Next", size: 14)!, .foregroundColor: UIColor.white]
    format.gradientColor = ("3854A5".hexColor, "2A1A6C".hexColor)

    return format
  }

  public var animation: EmptyStateAnimation { return EmptyStateAnimation.none }

  public var viewClass: OriginalEmptyStateView.Type { return OriginalEmptyStateView.self }


}
