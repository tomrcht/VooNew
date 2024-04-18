//
//  ProfileView.swift
//  Voonew
//
//  Created by Tom on 14/04/2024.
//

import SwiftUI

struct ProfileView: View {

  private enum Constants {
    static let defaultHeaderHeight: CGFloat = 300.0
    static let defaultContentCornerRadii: CGFloat = 48.0

    static let sheetPadding: CGFloat = Sizes.empty
  }

  @Environment(Context.self) private var context
  @StateObject private var viewModel: ProfileViewModel = .init()
  @State private var scrollViewOffset: CGFloat = .zero
  @State private var contentSize: ContentSize = .zero

  private let user: Friend
  private let journalViewConfiguration = JournalView.Configuration(showUserInformations: false, showActions: false)

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("dd MMMM")
    return formatter
  }()

  private var journalSize: CGSize {
    .init(
      width: (contentSize.size.width / 3.0) - Constants.sheetPadding * 2.0,
      height: (contentSize.size.width / 3.0)  - Constants.sheetPadding * 2.0
    )
  }

  init(user: Friend) {
    self.user = user
  }

  var body: some View {
    AScrollView(
      scrollViewOffset: $scrollViewOffset,
      headerDefaultHeight: Constants.defaultHeaderHeight,
      contentOffset: .init(width: 0.0, height: -75.0),
      header: { headerView },
      content: { contentView }
    )
    .scrollIndicators(.hidden)
    .readingSize(size: $contentSize, in: .global)
    .task {
      await viewModel.journals(for: user)
    }
  }

  private var headerView: some View {
    VStack(spacing: Sizes.large) {
      Image(user.ppName)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea(.all, edges: .top)
        .frame(maxHeight: Constants.defaultHeaderHeight)
    }
  }

  private var contentView: some View {
    VStack(spacing: Sizes.regular) {
      Text(user.name)
        .font(.system(size: 32.0, weight: .bold, design: .rounded))
        .foregroundStyle(.text)
        .lineLimit(2)
        .multilineTextAlignment(.center)

      HStack(spacing: Sizes.large) {
        Spacer()
        friendsCounter
        Spacer()
        streakCounter
        Spacer()
      }

      userContentView
        .padding(.top, Sizes.xLarge)

      Spacer()
    }
    .padding(.top, Sizes.xxLarge)
    .padding(.horizontal, Constants.sheetPadding)
    .frame(maxWidth: .infinity, minHeight: Constants.defaultHeaderHeight)
    .background {
      Color.appBackground
    }
    .clipShape(
      UnevenRoundedRectangle(cornerRadii: .init(topLeading: Constants.defaultContentCornerRadii, topTrailing: Constants.defaultContentCornerRadii))
    )
  }

  @ViewBuilder
  private var friendsCounter: some View {
    VStack(spacing: Sizes.xSmall) {
      Text("\(Int.random(in: 15 ... 86))")
        .font(.system(size: 24.0, weight: .bold, design: .rounded))
        .foregroundStyle(.text)

      Text("friends")
        .font(.system(size: 14.0))
        .opacity(0.8)
    }
  }

  @ViewBuilder
  private var streakCounter: some View {
    let streakCounter = Bool.random() ? Int.random(in: 32 ... 366) : 0

    VStack(spacing: Sizes.xSmall) {
      Image(systemName: "flame.fill")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(streakCounter == 0 ? Color.text.opacity(0.25).gradient : Color.orange.gradient)
        .frame(width: 24.0)

      Text("\(streakCounter) days streak")
        .font(.system(size: 14.0))
        .opacity(0.8)
    }
  }

  @ViewBuilder
  private var userContentView: some View {
    switch viewModel.state {
    case .loading:
      loadingView
    case .loaded(let journals):
      userContentListView(journals)
    case .error:
      errorView
    }
  }

  private var loadingView: some View {
    Text("Loading...")
  }

  private var errorView: some View {
    Text("!Error!")
  }

  @ViewBuilder
  private func userContentListView(_ journals: [Journal]) -> some View {
    Text("Journals")
      .font(.system(size: 32.0, weight: .bold, design: .rounded))
      .foregroundStyle(.text)
      .lineLimit(2)
      .multilineTextAlignment(.center)

    LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: Sizes.xSmall) {
      ForEach(journals) { journal in
        cover(journal.entries.first?.photos.first?.url)
          .frame(width: journalSize.width, height: journalSize.height)
          .clipped()
          .clipShape(clipShape)
          .overlay {
            ZStack {
              Color.black.opacity(0.5)
              VStack(spacing: Sizes.large) {
                Text(dateFormatter.string(from: journal.date))
                  .font(.system(size: 22.0, weight: .bold, design: .rounded))
                  .foregroundStyle(.thickMaterial)
                  .multilineTextAlignment(.center)
              }
            }
            .clipShape(clipShape)
            .allowsHitTesting(false)
          }
          .onTapGesture {
            selectJournal(journal)
          }
      }
    }
  }

  // MARK: - Journals

  @ViewBuilder
  private func cover(_ url: URL?) -> some View {
    AsyncImage(url: url) { image in
      image
        .resizable()
        .aspectRatio(contentMode: .fill)
    } placeholder: {
      RoundedRectangle(cornerRadius: 4.0)
        .fill(Color.black.opacity(0.2))
    }
  }

  // MARK: - helpers

  private var clipShape: some Shape {
    RoundedRectangle(cornerRadius: 4.0)
  }

  private func selectJournal(_ journal: Journal) {
    withAnimation {
      context.set(.details(journal))
    }
    context.isJournalSelected = true
  }
}

#Preview {
  ProfileView(user: .me)
    .environment(Context())
}
