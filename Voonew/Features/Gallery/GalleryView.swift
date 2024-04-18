//
//  GalleryView.swift
//  Voonew
//
//  Created by Tom on 17/04/2024.
//

import SwiftUI

struct SelectionContent: Identifiable, Hashable {
  let id: Photo.ID
  let photo: Photo
  let rotationAngle: Double

  init(photo: Photo, rotationAngle: Double) {
    self.id = photo.id
    self.photo = photo
    self.rotationAngle = rotationAngle
  }
}

struct GalleryView: View {

  @StateObject private var viewModel: GalleryViewModel = .init()
  @Environment(\.dismiss) private var dismiss
  @Namespace private var namespace

  @State private var context: Context = .selection
  @State private var contentSize: ContentSize = .zero
  @State private var showSelectedPhotos: Bool = false
  @State private var viewSelection: [SelectionContent] = []

  private var photoSize: CGSize {
    CGSize(
      width: contentSize.size.width / 3.0,
      height: contentSize.size.height / 4.0
    )
  }

  var body: some View {
    VStack {
      switch viewModel.state {
      case .loading:
        Text("Loading...")
      case .loaded(let photos):
        contentView(photos)
      case .error:
        Text("Error :(")
      }
    }
    .readingSize(size: $contentSize, in: .global)
    .task {
      await viewModel.photos()
    }
  }

  @ViewBuilder
  private func contentView(_ photos: [Photo]) -> some View {
    VStack(spacing: 0) {
      headerRow
        .padding(Sizes.regular)
      switch context {
      case .selection:
        selectionContentView(photos)
          .transition(.move(edge: .leading).combined(with: .opacity))
      case .final:
        GalleryFinalView(context: $context, photos: viewSelection.map { $0.photo })
          .transition(.move(edge: .trailing).combined(with: .opacity))
      }
      if !viewModel.selection.isEmpty {
        actionsRow
      }
    }
  }

  @ViewBuilder
  private func selectionContentView(_ photos: [Photo]) -> some View {
    photosList(photos)

    if showSelectedPhotos {
      selectedPhotosRow
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
  }

  private var headerRow: some View {
    HStack {
      Text("Only today's photos are shown; share your day!")
        .font(.system(size: 14.0, weight: .bold))
        .foregroundStyle(.text.opacity(0.8))
      Spacer()
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark")
          .resizable()
          .scaledToFit()
          .frame(width: 12.0)
          .padding(Sizes.regular)
          .foregroundStyle(.text.opacity(0.8))
          .background {
            Circle()
              .fill(.text.opacity(0.2))
          }
      }
    }
  }

  @ViewBuilder
  private func photosList(_ photos: [Photo]) -> some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: Sizes.xSmall) {
        ForEach(photos) { photo in
          let isSelected = viewModel.selection.contains(photo)
          photoView(photo.url)
            .frame(width: photoSize.width, height: photoSize.height)
            .clipped()
            .clipShape(clipShape)
            .transition(.scale)
            .animation(.spring, value: viewModel.selection)
            .blur(radius: isSelected ? 2.5 : 0.0)
            .onTapGesture {
              withAnimation { didTapPhoto(photo) }
            }
            .overlay {
              if isSelected {
                Image(systemName: "checkmark.circle.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 24.0)
                  .foregroundStyle(.text)
              }
            }
        }
      }
    }
    .scrollIndicators(.hidden)
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

  @ViewBuilder
  private var actionsRow: some View {
    HStack {
      switch context {
      case .selection:
        selectionContextActions
      case .final:
        finalContextActions
      }
    }
    .transition(.move(edge: .bottom).combined(with: .opacity))
    .padding(.horizontal, Sizes.large)
    .padding(.top, Sizes.large)
    .frame(maxWidth: .infinity)
    .background(.thickMaterial)
  }

  @ViewBuilder
  private var selectionContextActions: some View {
    ZStack {
      ForEach(viewSelection) { selection in
        photoView(selection.photo.url)
          .frame(width: 60.0, height: 60.0)
          .clipped()
          .clipShape(clipShape)
          .rotationEffect(.degrees(selection.rotationAngle))
          .animation(.spring, value: viewModel.selection)
      }
    }
    .overlay {
      Text(String(viewModel.selection.count))
        .font(.system(size: 12.0, weight: .bold))
        .foregroundStyle(.text)
        .padding(Sizes.regular)
        .background(.regularMaterial)
        .clipShape(Circle())
    }
    .onTapGesture {
      withAnimation { showSelectedPhotos.toggle() }
    }
    Spacer()
    Button {
      withAnimation {
        context = .final
      }
    } label: {
      Image(systemName: "arrow.forward")
        .resizable()
        .scaledToFit()
        .frame(width: 24.0)
        .foregroundStyle(.text)
    }
    .matchedGeometryEffect(id: "actionButton", in: namespace, isSource: true)
    .animation(.spring, value: context)
  }

  @ViewBuilder
  private var finalContextActions: some View {
    Button {
      withAnimation {
        context = .selection
      }
    } label: {
      Image(systemName: "arrow.backward")
        .resizable()
        .scaledToFit()
        .frame(width: 24.0)
        .foregroundStyle(.text)
    }
    .frame(height: 60.0)
    .matchedGeometryEffect(id: "actionButton", in: namespace, isSource: false)
    .animation(.spring, value: context)

    Spacer()

    Button("Post!") {
      //
    }
    .padding(.vertical, Sizes.large)
    .padding(.horizontal, Sizes.xLarge)
    .background { Color.text }
    .foregroundStyle(.textInverse)
    .font(.system(size: 14.0, weight: .bold, design: .rounded))
    .clipShape(Capsule())
  }

  private var selectedPhotosRow: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: Sizes.regular) {
        ForEach(viewSelection) { selection in
          photoView(selection.photo.url)
            .frame(width: 80, height: 160.0)
            .clipped()
            .clipShape(clipShape)
            .animation(.spring, value: viewModel.selection)
            .onTapGesture {
              withAnimation { didTapPhoto(selection.photo) }
            }
        }
      }
      .padding(Sizes.regular)
    }
    .scrollIndicators(.hidden)
    .frame(maxHeight: 160.0 + Sizes.regular * 2.0)
    .background(.thinMaterial)
  }

  // MARK: - Helper

  private var clipShape: some Shape {
    RoundedRectangle(cornerRadius: 4.0)
  }

  private func didTapPhoto(_ photo: Photo) {
    viewModel.onTapPhoto(photo)

    if let index = viewSelection.firstIndex(where: { $0.id == photo.id }) {
      viewSelection.remove(at: index)
    } else {
      let content = SelectionContent(
        photo: photo,
        rotationAngle: Double.random(in: -30 ... 30)
      )
      viewSelection.append(content)
    }

    if viewSelection.isEmpty {
      showSelectedPhotos = false
    }
  }
}

extension GalleryView {
  enum Context {
    case selection
    case final
  }
}

#Preview {
  GalleryView()
}
