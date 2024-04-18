//
//  JournalDetailsView.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import SwiftUI

struct JournalDetailsView: View {

  @Environment(Context.self) private var context
  @State private var isLiked: Bool = false
  @State private var contentSize: ContentSize = .zero
  @State private var scrollViewOffset: CGFloat = .zero
  @State private var showCommentsSheet: Bool = false
  private let journal: Journal

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE, dd MMMM")
    return formatter
  }()

  init(journal: Journal) {
    self.journal = journal
  }

  var body: some View {
    VStack {
      AScrollView(
        scrollViewOffset: $scrollViewOffset,
        headerDefaultHeight: 250.0,
        contentOffset: .init(width: 0, height: Sizes.large)
      ) {
        HStack {
          VStack(alignment: .leading, spacing: Sizes.small) {
            if let name = journal.name {
              Text(name)
                .font(.system(size: 32.0, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(2)
            }

            HStack(spacing: Sizes.small) {
              Text("By")
                .font(.system(size: 14.0, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))

              Text("\(journal.owner.name)")
                .font(.system(size: 14.0, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
//                .underline()

              Text("on \(dateFormatter.string(from: journal.date))")
                .font(.system(size: 14.0, weight: .bold, design: .rounded))
                .foregroundStyle(.white.opacity(0.8))
            }
          }
          Spacer()
        }
        .padding(Sizes.large)
        .blur(radius: scrollViewOffset < 0 ? abs(scrollViewOffset) * 0.1 : 0)
        .animation(.easeInOut, value: scrollViewOffset)
      } content: {
        LazyVStack(spacing: Sizes.xxLarge) {
          ForEach(journal.entries) { entry in
            entryView(for: entry)
          }
        }
        .background { Color.black.clipShape(clipShape).padding(.horizontal, Sizes.regular) }
      }
    }
    .background { Color.black.ignoresSafeArea() }
    .readingSize(size: $contentSize, in: .global)
    .sheet(isPresented: $showCommentsSheet) {
      CommentsView()
        .presentationDetents([.fraction(0.75), .fraction(1.0)])
    }
  }

  @ViewBuilder
  private func entryView(for entry: Journal.Entry) -> some View {
    VStack(alignment: .leading, spacing: Sizes.small) {
      ScrollView(.horizontal) {
        LazyHStack(spacing: Sizes.regular) {
          ForEach(entry.photos) { photo in
            let widthRatio = entry.photos.count == 1 ? 1 : 0.9
            let singlePhotoDelta = entry.photos.count == 1 ? Sizes.regular * 2.0 : 0
            let photoSize = CGSize(
              width: max(0, contentSize.size.width * widthRatio - singlePhotoDelta),
              height: contentSize.size.height * 0.9
            )
            photoView(photo, size: photoSize)
          }
        }
        .scrollTargetLayout()
        .padding(.horizontal, Sizes.regular)
      }
      .scrollTargetBehavior(.viewAligned)

      entryToolbar(entry)
        .padding(.horizontal, Sizes.large)
    }
  }

  @ViewBuilder
  private func photoView(_ photo: Photo, size: CGSize) -> some View {
    AsyncImageHack(url: photo.url) { phase in
      switch phase {
      case .empty:
        clipShape
          .fill(Color.white.opacity(0.25))
          .frame(width: size.width, height: size.height)
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: size.width, height: size.height)
          .clipped()
          .clipShape(clipShape)
      case .failure(let error):
        clipShape
          .fill(Color.red.opacity(0.2))
          .overlay {
            Text("error : \(error.localizedDescription)")
              .fontWeight(.bold)
              .foregroundStyle(.red)
          }
      @unknown default:
        Text("?")
      }
    }
  }

  @ViewBuilder
  private func entryAuthorInformations(for author: Friend) -> some View {
    HStack(spacing: Sizes.regular) {
      UserProfilePicture(pictureName: author.ppName)
        .frame(width: 32.0)
      Text(author.name)
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(.white.opacity(0.8))
    }
    .onTapGesture {
      withAnimation { context.set(.profile(author)) }
    }
  }

  @ViewBuilder
  private func entryToolbar(_ entry: Journal.Entry) -> some View {
    HStack(alignment: .center, spacing: Sizes.large) {
      entryAuthorInformations(for: entry.author)
      Spacer()
      Button {
        showCommentsSheet.toggle()
      } label: {
        actionIcon("bubble")
      }

      Button {
        //
      } label: {
        actionIcon("paperplane")
      }

      Button {
        withAnimation { isLiked.toggle() }
      } label: {
        Image(systemName: isLiked ? "heart.fill" : "heart")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24.0)
          .foregroundStyle(isLiked ? .pink : .white)
      }
    }
  }

  @ViewBuilder
  private func actionIcon(_ name: String) -> some View {
    Image(systemName: name)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 24.0)
      .foregroundStyle(.white)
  }

  private var clipShape: some Shape {
    RoundedRectangle(cornerRadius: 24.0)
  }
}

#Preview {
  NavigationStack {
    JournalDetailsView(
      journal: .init(id: .random(), date: .now, owner: .me, name: "Some name", entries: [
        .init(
          id: .random(),
          author: .me,
          photos: Mocks.photos().shuffled()
        ),
        .init(
          id: .random(),
          author: .lancey,
          photos: Mocks.photos().shuffled()
        ),
        .init(
          id: .random(),
          author: .yeat,
          photos: Mocks.photos().shuffled()
        ),
        .init(
          id: .random(),
          author: .travis,
          photos: Mocks.photos().shuffled()
        ),
        .init(
          id: .random(),
          author: .kali,
          photos: Mocks.photos().shuffled()
        ),
      ])
    )
  }
  .environment(Context())
}
