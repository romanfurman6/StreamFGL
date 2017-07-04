//
//  Reusable.swift
//  Freebird
//
//  Created by Evgeny Matviyenko on 12/16/16.
//  Copyright © 2016 MobileOffers, Inc. All rights reserved.
//

import Foundation

protocol ReusableCell {
  static var reuseIdentifier: String { get }
}

extension ReusableCell {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
}

extension UITableView {
  func dequeueReusableCell<Cell: ReusableCell>(withType type: Cell.Type, forRowAt indexPath: IndexPath) -> Cell {
    guard let cell = self.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
      fatalError("Could not dequeue reusable cell with \(Cell.reuseIdentifier) reuse identifier.")
    }

    return cell
  }
}

extension UICollectionView {
  func dequeueReusableCell<Cell: ReusableCell>(withType type: Cell.Type, forItemAt indexPath: IndexPath) -> Cell {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
      fatalError("Could not dequeue reusable cell with \(Cell.reuseIdentifier) reuse identifier.")
    }

    return cell
  }
}
