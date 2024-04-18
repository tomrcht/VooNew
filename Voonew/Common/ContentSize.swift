//
//  ContentSize.swift
//  Voonew
//
//  Created by Tom on 14/04/2024.
//

import Foundation
import SwiftUI

struct ContentSize: Equatable {
  let frame: CGRect
  let size: CGSize
  let safeAreaInsets: EdgeInsets

  static var zero: Self {
    .init(frame: .zero, size: .zero, safeAreaInsets: .init())
  }
}
