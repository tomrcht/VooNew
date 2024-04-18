//
//  CommentsView.swift
//  Voonew
//
//  Created by Tom on 16/04/2024.
//

import SwiftUI

struct CommentsView: View {

  @StateObject private var viewModel = CommentsViewModel()
  @State private var selectedReaction: String?
  @State private var addCommentOverlaySize: ContentSize = .zero
  
  @FocusState private var isCommentFieldFocused: Bool
  @State private var text: String = ""
  @State private var scrollPosition: Comment.ID?

  private let reactions: [String] = ["❤️", "😂", "🎉", "😡", "😭", "🤝", "🤯", "👀", "🍑", "🧸"]

  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        reactionsRow
        Divider()
          .background { Color.text.opacity(0.5) }
      }

      commentsList
        .onTapGesture {
          isCommentFieldFocused = false
        }
    }
    .overlay(alignment: .bottom) {
      HStack(spacing: Sizes.regular) {
        TextField("Write something...", text: $text)
          .focused($isCommentFieldFocused)
          .padding(Sizes.large)
          .background { Color.appBackground.clipShape(Capsule()) }
          .padding(.vertical, Sizes.large)
        Button {
          commitComment()
        } label: {
          Image(systemName: "paperplane")
            .resizable()
            .scaledToFit()
            .frame(width: 24.0)
            .foregroundStyle(text.isEmpty ? .black.opacity(0.25) : .text)
        }
        .disabled(text.isEmpty)
      }
      .padding([.horizontal, .bottom], Sizes.large)
      .frame(maxWidth: .infinity)
      .background(.thinMaterial)
      .onTapGesture {
        isCommentFieldFocused = true
      }
      .readingSize(size: $addCommentOverlaySize, in: .global)
    }
    .ignoresSafeArea(.container, edges: .bottom)
    .task {
      await viewModel.fetch()
    }
    .onChange(of: isCommentFieldFocused) { _, isFocused in
      if isFocused {
        scrollPosition = viewModel.comments.last?.id
      }
    }
  }

  private var reactionsRow: some View {
    ScrollView(.horizontal) {
      HStack(spacing: Sizes.large) {
        ForEach(reactions, id: \.self) { reaction in
          Text(reaction)
            .font(.largeTitle)
            .scaleEffect(selectedReaction == reaction ? 1.25 : 1.0)
            .offset(y: selectedReaction == reaction ? -5.0 : 0)
            .animation(.spring(duration: 0.15), value: selectedReaction)
            .onTapGesture {
              text.append(reaction)
            }
        }
      }
      .padding(.vertical, Sizes.xLarge)
      .padding(.horizontal, Sizes.large)
    }
    .scrollIndicators(.hidden)
  }

  // MARK: - Comments

  @ViewBuilder
  private var commentsList: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: Sizes.regular) {
        ForEach(viewModel.comments) { comment in
          commentView(comment)
            .padding(.horizontal, Sizes.regular)
        }
      }
      .padding(.top, Sizes.large)
      .padding(.bottom, addCommentOverlaySize.size.height + Sizes.large)
    }
    .scrollPosition(id: $scrollPosition, anchor: .center)
  }

  @ViewBuilder
  private func commentView(_ comment: Comment) -> some View {
    let iAmAuthor = comment.author == .me

    HStack {
      if iAmAuthor { Spacer() }

      HStack(alignment: .center) {
        if !iAmAuthor {
          UserProfilePicture(pictureName: comment.author.ppName)
            .frame(width: 32.0)
        }

        VStack(alignment: .leading, spacing: Sizes.xSmall) {
          if !iAmAuthor {
            Text(comment.author.name)
              .font(.system(size: 12.0, weight: .bold))
              .foregroundStyle(.text)
              .opacity(0.8)
          }

          Text(comment.content)
            .font(.system(size: 14.0))
            .multilineTextAlignment(.leading)
            .foregroundStyle(.text)
            .padding(Sizes.regular)
            .background {
              RoundedRectangle(cornerRadius: 8.0)
                .fill(iAmAuthor ? .blue.opacity(0.2) : .text.opacity(0.1))
            }
        }
      }


      if !iAmAuthor { Spacer() }
    }
  }

  private func commitComment() {
    Task {
      let newComment = await viewModel.comment(text: text)
      text = ""
      withAnimation {
        scrollPosition = newComment.id
      }
    }
  }
}

#Preview {
  Text("!")
    .sheet(isPresented: .constant(true)) {
      CommentsView()
        .presentationDetents([.fraction(0.75), .fraction(1)])
    }
}
