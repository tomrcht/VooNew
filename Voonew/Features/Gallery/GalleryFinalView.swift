//
//  GalleryFinalView.swift
//  Voonew
//
//  Created by Tom on 17/04/2024.
//

import SwiftUI

struct GalleryFinalView: View {

  private enum Constants {
    static let photosHeight: CGFloat = 200.0
    static let photosRatio: CGFloat = 9 / 16

    static let titles: [String] = [
      "A ✨great✨ day",
      "Japan 2024 🎌",
      "Trip to Paris 🥖🍷🇫🇷",
      "Rain and chill ☺️",
    ]
  }

  @State private var journalTitle: String = ""
  @Binding private var context: GalleryView.Context
  @FocusState private var isTitleFocused: Bool

  private let photos: [Photo]

  init(context: Binding<GalleryView.Context>, photos: [Photo]) {
    self._context = context
    self.photos = photos
  }

  // MARK

  var body: some View {
    VStack(spacing: 0) {

      VStack(alignment: .leading, spacing: Sizes.small) {
        sectionTitle("Your photos")
          .padding(.horizontal, Sizes.large)

        ScrollView(.horizontal) {
          LazyHStack(spacing: Sizes.regular) {
            ForEach(photos) { photo in
              photoView(photo.url)
                .frame(maxWidth: Constants.photosHeight * Constants.photosRatio, maxHeight: Constants.photosHeight)
                .clipped()
                .clipShape(clipShape)
            }
          }
          .padding(.horizontal, Sizes.large)
        }
        .scrollIndicators(.hidden)
        .frame(maxHeight: Constants.photosHeight)
      }

      Divider()
        .padding(.vertical, Sizes.xLarge)

      VStack(alignment: .leading, spacing: Sizes.small) {
        sectionTitle("Journal title (optional)")

        TextField(Constants.titles.randomElement()!, text: $journalTitle)
          .focused($isTitleFocused)
          .font(.system(size: 32.0, weight: .bold, design: .rounded))
          .foregroundStyle(.text)
      }
      .padding(.horizontal, Sizes.large)

      Spacer()
    }
    .onTapGesture {
      isTitleFocused = false
    }
  }

  @ViewBuilder
  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(.system(size: 14.0, weight: .bold))
      .foregroundStyle(.text.opacity(0.8))
  }

  @ViewBuilder
  private func photoView(_ url: URL?) -> some View {
    AsyncImageHack(url: url) { phase in
      switch phase {
      case .empty:
        clipShape
          .fill(Color.black.opacity(0.25))
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      case .failure:
        clipShape
          .fill(Color.red.opacity(0.25))
      @unknown default:
        Text("?")
      }
    }
  }

  private var clipShape: some Shape {
    RoundedRectangle(cornerRadius: 4.0)
  }
}

#Preview {
  GalleryFinalView(context: .constant(.final), photos: Mocks.photos())
}
