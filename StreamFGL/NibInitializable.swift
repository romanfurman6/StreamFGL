//
//  NibInitializable.swift
//  Freebird
//
//  Created by Evgeny Matviyenko on 12/21/16.
//  Copyright © 2016 MobileOffers, Inc. All rights reserved.
//

import Foundation

protocol NibInitializable {
  static var nibName: String { get }
  static func initFromNib() -> Self
}

extension NibInitializable where Self: UIView {
  static var nibName: String {
    return String(describing: Self.self)
  }

  static var nib: UINib {
    return UINib(nibName: nibName, bundle: nil)
  }

  static func initFromNib() -> Self {
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError("Could not instantiate view from nib with name \(nibName).")
    }

    return view
  }
}
