//
//  HomeView.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import SwiftUI

struct HomeView: View {

  typealias ViewModel = HomeViewModel

  // MARK: - Properties

  @Environment(Context.self) private var context
  @StateObject private var viewModel: ViewModel = .init()

  @State private var contentSize: ContentSize = .zero
  @State private var showCommentsSheet: Bool = false
  @State private var showGallerySheet: Bool = false
  @Binding private var navigationPath: NavigationPath

  private var journalSize: CGSize {
    guard contentSize != .zero else { return .zero }
    return CGSize(width: contentSize.size.width, height: contentSize.size.height * 0.9)
  }

  // MARK: - init

  init(navigationPath: Binding<NavigationPath>) {
    self._navigationPath = navigationPath
  }

  // MARK: - UI

  var body: some View {
    VStack {
      switch viewModel.state {
      case .loading:
        loadingView
      case .loaded(let journals):
        contextView(journals)
      case .error:
        errorView
      }
    }
    .toolbar(.visible, for: .navigationBar)
    .toolbarBackground(.hidden, for: .navigationBar)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        contextButtons
      }
      ToolbarItem(placement: .topBarTrailing) {
        if context.isToday {
          addButton
        }
      }
    }
    .sheet(isPresented: $showCommentsSheet) {
      CommentsView()
        .presentationDetents([.fraction(0.75), .fraction(1.0)])
    }
    .sheet(isPresented: $showGallerySheet) {
      GalleryView()
    }
    .task {
      await viewModel.journals()
    }
  }

  private var loadingView: some View {
    Text("Loading...")
  }
  private var errorView: some View {
    Text("Error :(")
  }

  @ViewBuilder
  private func contextView(_ journals: [Journal]) -> some View {
    switch context.value {
    case .profile(let friend):
      ProfileView(user: friend)
        .transition(.move(edge: .leading).combined(with: .opacity))
        .environment(context)
    case .today:
      journalsContentView(journals)
        .transition(context.isJournalSelected ? .move(edge: .leading) : .move(edge: .trailing))
    case .details(let journal):
      JournalDetailsView(journal: journal)
        .transition(.move(edge: .trailing).combined(with: .opacity))
        .environment(context)
    }
  }

  @ViewBuilder
  private func journalsContentView(_ journals: [Journal]) -> some View {
    ScrollView {
      LazyVStack(spacing: Sizes.small) {
        ForEach(journals) { journal in
          JournalView(
            journal: journal,
            size: journalSize,
            onTapJournal: onJournalSelect,
            onTapFriend: onFriendSelect,
            onTapComments: onCommentsSelect
          )
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
    .background { Color.appBackground }
    .readingSize(size: $contentSize, in: .global)
    .ignoresSafeArea(.all, edges: .all)
  }

  // MARK: - Toolbar

  private var contextButtons: some View {
    HStack(spacing: Sizes.large) {
      Button(context.profileName) {
        withAnimation {
          context.set(.profile(.me))
        }
        if context.isJournalSelected { context.isJournalSelected = false }
      }
      .font(.system(size: 16.0, weight: .bold, design: .rounded))
      .foregroundStyle(.ultraThickMaterial)
      .overlay(alignment: .bottom) {
        if context.value.isProfile {
          contextIndicator
            .animation(.interactiveSpring, value: context.value)
            .offset(y: 7.0)
        }
      }

      Button("Today") {
        withAnimation {
          context.set(.today)
        }
        if context.isJournalSelected { context.isJournalSelected = false }
      }
      .font(.system(size: 16.0, weight: .bold, design: .rounded))
      .foregroundStyle(.ultraThickMaterial)
      .overlay(alignment: .bottom) {
        if context.value.isToday {
          contextIndicator
            .animation(.interactiveSpring, value: context.value)
            .offset(y: 7.0)
        }
      }

      Button("Journal") {
        //
      }
      .font(.system(size: 16.0, weight: .bold, design: .rounded))
      .foregroundStyle(.ultraThickMaterial)
      .opacity(context.isDetails ? 1.0 : 0.0)
      .overlay(alignment: .bottom) {
        if context.value.isDetails {
          contextIndicator
            .animation(.interactiveSpring, value: context.value)
            .offset(y: 7.0)
        }
      }
    }
    .shadow(color: .text, radius: 4)
  }

  private var addButton: some View {
    Button {
      showGallerySheet.toggle()
    } label: {
      Image(systemName: "plus")
        .foregroundStyle(.text)
        .font(.system(size: 14.0, weight: .bold, design: .rounded))
        .padding(.horizontal, Sizes.large)
        .padding(.vertical, Sizes.regular)
        .background(.thinMaterial)
        .clipShape(Circle())
    }
    .animation(.easeInOut, value: context.value)
  }

  private var contextIndicator: some View {
    Circle()
      .fill(Color.pink)
      .aspectRatio(contentMode: .fit)
      .frame(width: 6.0)
  }

  // MARK: - Helpers

  private func onJournalSelect(_ journal: Journal) {
    context.isJournalSelected = true
    withAnimation {
      context.set(.details(journal))
    }
  }

  private func onFriendSelect(_ friend: Friend) {
    withAnimation {
      context.set(.profile(friend))
    }
    if context.isJournalSelected { context.isJournalSelected = false }
  }

  private func onCommentsSelect(_ journal: Journal) {
    showCommentsSheet.toggle()
  }
}

// MARK: - Preview

#Preview {
  NavigationStack {
    HomeView(navigationPath: .constant(NavigationPath()))
  }
  .environment(Context())
}
