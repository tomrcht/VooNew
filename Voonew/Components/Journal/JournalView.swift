//
//  JournalView.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import SwiftUI

struct JournalView: View {

  private enum Constants {
    static let ownerPictureSize: CGFloat = 40.0
  }

  @State private var isLiked: Bool = false

  private let journal: Journal
  private let size: CGSize
  private let configuration: Configuration

  private let onTapJournal: ((Journal) -> Void)?
  private let onTapFriend: ((Friend) -> Void)?
  private let onTapComments: ((Journal) -> Void)?

  private var coverImageURL: URL? {
    journal.entries.first?.photos.first?.url
  }

  init(
    journal: Journal,
    size: CGSize,
    configuration: Configuration = .default,
    onTapJournal: ((Journal) -> Void)? = nil,
    onTapFriend: ((Friend) -> Void)? = nil,
    onTapComments: ((Journal) -> Void)? = nil
  ) {
    self.journal = journal
    self.size = size
    self.configuration = configuration

    self.onTapJournal = onTapJournal
    self.onTapFriend = onTapFriend
    self.onTapComments = onTapComments
  }

  var body: some View {
    coverImage
      .frame(width: size.width, height: size.height)
      .clipped()
      .clipShape(Rectangle())
      .onTapGesture {
        onTapJournal?(journal)
      }
      .overlay(alignment: .bottomLeading) {
        informations
      }
      .ignoresSafeArea(.all, edges: .all)
  }

  private var informations: some View {
    HStack(alignment: .bottom, spacing: Sizes.regular) {
      VStack(alignment: .leading, spacing: Sizes.regular) {
        if configuration.showUserInformations {
          HStack(alignment: .bottom, spacing: Sizes.regular) {
            UserProfilePicture(pictureName: journal.owner.ppName)
              .frame(width: Constants.ownerPictureSize)
              .onTapGesture {
                onTapFriend?(journal.owner)
              }
            Text("By \(journal.owner.name)")
              .font(.system(size: 14.0, weight: .bold, design: .rounded))
              .foregroundStyle(.white.opacity(0.8))
          }
        }

        if let name = journal.name, !name.isEmpty {
          Text(name)
            .font(.system(size: 28.0, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .lineLimit(1)
        }
      }
      Spacer()

      if configuration.showActions {
        actionsRow
      }
    }
    .padding(.horizontal, Sizes.large)
    .padding(.vertical, Sizes.xLarge)
    .frame(maxWidth: .infinity)
    .background {
      LinearGradient(
        stops: [
          .init(color: .black, location: 0.0),
          .init(color: .black.opacity(0), location: 1.0)
        ],
        startPoint: .bottom,
        endPoint: .top
      )
    }
  }

  private var actionsRow: some View {
    HStack(alignment: .center, spacing: Sizes.large) {
      Button {
        onTapComments?(journal)
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

  private var coverImage: some View {
    AsyncImageHack(url: coverImageURL) { phase in
      switch phase {
      case .empty:
        RoundedRectangle(cornerRadius: 4.0)
          .fill(Color.black.opacity(0.2))
          .overlay { ProgressView() }
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      case .failure(let error):
        RoundedRectangle(cornerRadius: 4.0)
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
}

extension JournalView {
  struct Configuration {
    let showUserInformations: Bool
    let showActions: Bool

    static var `default`: Self {
      .init(showUserInformations: true, showActions: true)
    }
  }
}

#Preview {
  JournalView(
    journal: .init(id: .random(), date: .now, owner: .me, name: "Megabyte", entries: [
      .init(id: .random(), author: .me, photos: [.init(url: URL(string: "https://avatars.githubusercontent.com/u/7870872"))])
    ]),
    size: .init(width: 400, height: 600)
  )
}

#Preview("No journal name") {
  JournalView(
    journal: .init(id: .random(), date: .now, owner: .me, name: nil, entries: [
      .init(id: .random(), author: .me, photos: [.init(url: URL(string: "https://avatars.githubusercontent.com/u/7870872"))])
    ]),
    size: .init(width: 400, height: 600)
  )
}
