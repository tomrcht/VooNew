//
//  OffsetScrollView.swift
//  Voonew
//
//  Created by Tom on 14/04/2024.
//

import SwiftUI

// MARK: - Coordinates namespace

private enum OffsetScrollViewCoordinateSpace {
  static let namespace = "OffsetScrollView_coordinateSpace"
}

struct OffsetScrollView<Content: View>: View {

  @Binding private var offset: CGFloat
  private let axis: Axis.Set
  private let content: Content

  init(
    offset: Binding<CGFloat> = .constant(.zero),
    axis: Axis.Set = .vertical,
    @ViewBuilder content: () -> Content
  ) {
    self._offset = offset
    self.axis = axis
    self.content = content()
  }

  var body: some View {
    ScrollView(axis) {
      content
        .readingOffset(in: .named(OffsetScrollViewCoordinateSpace.namespace))
    }
    .coordinateSpace(name: OffsetScrollViewCoordinateSpace.namespace)
    .onPreferenceChange(OffsetKey.self) { offset = $0 }
  }
}

#Preview {
  OffsetScrollView { }
}
