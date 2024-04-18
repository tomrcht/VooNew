//
//  SizeReader.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import SwiftUI

struct SizeReaderPreferenceKey: PreferenceKey {
  static var defaultValue: ContentSize = .zero
  static func reduce(value: inout ContentSize, nextValue: () -> ContentSize) {
    value = nextValue()
  }
}

private struct SizeReaderModifier<T: CoordinateSpaceProtocol>: ViewModifier {

  @Binding private var size: ContentSize
  private let coordinateSpace: T

  init(size: Binding<ContentSize> = .constant(.zero), coordinateSpace: T) {
    self._size = size
    self.coordinateSpace = coordinateSpace
  }

  func body(content: Content) -> some View {
    content
      .overlay {
        GeometryReader { reader in
          Color
            .clear
            .preference(
              key: SizeReaderPreferenceKey.self,
              value: ContentSize(frame: reader.frame(in: coordinateSpace), size: reader.size, safeAreaInsets: reader.safeAreaInsets)
            )
        }
        .onPreferenceChange(SizeReaderPreferenceKey.self) { size = $0 }
      }
  }
}

extension View {
  func readingSize<T: CoordinateSpaceProtocol>(size: Binding<ContentSize>, in coordinateSpace: T) -> some View {
    modifier(SizeReaderModifier(size: size, coordinateSpace: coordinateSpace))
  }

  func readingSize<T: CoordinateSpaceProtocol>(in coordinateSpace: T) -> some View {
    modifier(SizeReaderModifier(coordinateSpace: coordinateSpace))
  }
}

