//
//  AScrollView.swift
//  Voonew
//
//  Created by Tom on 14/04/2024.
//

import SwiftUI

struct AScrollView<Header: View, Content: View>: View {

  @State private var headerSize: ContentSize? = nil
  @Binding private var scrollViewOffset: CGFloat

  private let axis: Axis.Set
  private let headerDefaultHeight: CGFloat
  private let contentOffset: CGSize

  private let header: () -> Header
  private let content: () -> Content

  init(
    scrollViewOffset: Binding<CGFloat> = .constant(.zero),
    axis: Axis.Set = .vertical,
    headerDefaultHeight: CGFloat,
    contentOffset: CGSize = .zero,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self._scrollViewOffset = scrollViewOffset

    self.axis = axis
    self.headerDefaultHeight = headerDefaultHeight
    self.contentOffset = contentOffset

    self.header = header
    self.content = content
  }

  var body: some View {
    ZStack(alignment: .top) {
      header()
        .readingSize(in: .global)
        .onPreferenceChange(SizeReaderPreferenceKey.self) { size in
          if headerSize == nil { headerSize = size }
        }

      OffsetScrollView(offset: $scrollViewOffset, axis: axis) {
        VStack(spacing: Sizes.empty) {
          invisibleHeaderOffsetContainer
            .allowsHitTesting(false)
          content()
            .offset(contentOffset)
        }
      }
    }
  }

  private var invisibleHeaderOffsetContainer: some View {
    Color
      .clear
      .frame(height: headerSize?.size.height ?? 0.0)
  }
}

#Preview {
  AScrollView(axis: .vertical, headerDefaultHeight: 350.0) {
    Text("HI!")
      .frame(maxWidth: .infinity, minHeight: 350.0)
      .background { Color.red }
  } content: {
    VStack {
      ForEach(0...100, id: \.self) { i in
        Text("Content \(i)")
      }
    }
    .frame(maxWidth: .infinity)
    .background { Color.blue }
  }
  .ignoresSafeArea(.all, edges: .top)
}
