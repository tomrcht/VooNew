//
//  CommentsViewModel.swift
//  Voonew
//
//  Created by Tom on 16/04/2024.
//

import Foundation
import SwiftUI

final class CommentsViewModel: ObservableObject {
  @Published private(set) var comments: [Comment] = []

  @MainActor
  func fetch() async {
    comments = Mocks.comments()
  }

  @MainActor
  @discardableResult
  func comment(text: String) async -> Comment {
    let newComment = Comment(id: .random(), author: .me, content: text)
    comments.append(newComment)
    return newComment
  }
}
