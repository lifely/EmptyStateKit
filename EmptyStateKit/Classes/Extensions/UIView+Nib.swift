//
//  FromNib.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 23/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

extension UIView {

  func fixConstraintsInView(_ container: UIView!, insert: Bool = true) -> Void {
    guard let container = container else { return }

    self.translatesAutoresizingMaskIntoConstraints = false
    self.frame = CGRect(origin: .zero, size: container.frame.size)
    if insert == true { container.addSubview(self) }

    self.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
    self.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    self.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
    self.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
  }

}
