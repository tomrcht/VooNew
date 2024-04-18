//
//  OffsetReader.swift
//  Voonew
//
//  Created by Tom on 14/04/2024.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
  typealias Value = CGFloat

  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

struct OffsetContentView<T: CoordinateSpaceProtocol>: View {

  private let coordinateSpace: T

  init(coordinateSpace: T) {
    self.coordinateSpace = coordinateSpace
  }

  var body: some View {
    GeometryReader { proxy in
      Color
        .clear
        .preference(key: OffsetKey.self, value: proxy.frame(in: coordinateSpace).minY)
    }
  }
}

extension View {
  @ViewBuilder
  func readingOffset<T: CoordinateSpaceProtocol>(in coordinateSpace: T) -> some View {
    overlay { OffsetContentView(coordinateSpace: coordinateSpace) }
  }
}

