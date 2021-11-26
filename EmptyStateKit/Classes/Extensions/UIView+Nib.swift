//
//  FromNib.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 23/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

extension UIView {

  func fixConstraintsInView(_ container: UIView!, insert: Bool = true, matchFrame: Bool = false) -> Void {
    guard let container = container else { return }

    translatesAutoresizingMaskIntoConstraints = false
    if matchFrame == true { frame = CGRect(origin: .zero, size: container.bounds.size) }
    if insert == true { container.addSubview(self) }

    topAnchor.constraint(equalTo: container.topAnchor).isActive = true
    bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true

    setNeedsLayout() ; layoutSubviews()
  }

}
