//
//  ProfileViewModel.swift
//  Voonew
//
//  Created by Tom on 14/04/2024.
//

import Foundation

final class ProfileViewModel: ObservableObject {
  @Published private(set) var state: State = .loading

  private let unsplash = UnsplashService(apiKey: "8j7cdQS9HM1tfIomk_dUwqrIZ7wnymEECz6xk6OPP6k")

  func journals(for owner: Friend) async {
    await stateLoading()

    do {
//      let photos: [Photo] = Mocks.photos()
      let rawPhotos = try await unsplash.random(25)
      let photos = rawPhotos.map { Photo(from: $0) }

      var journals: [Journal] = []
      for index in 0 ... Int.random(in: 10...25) {
        journals.append(mockJournal(offset: index, owner: owner, photos: photos))
      }

      await stateLoaded(journals)
    } catch {
      await stateError()
    }
  }

  private func mockJournal(offset: Int, owner: Friend, photos: [Photo]) -> Journal {
    Journal(
      id: .random(),
      date: getDate(offset: offset),
      owner: owner,
      name: Journal.mockName(),
      entries: [
        .init(id: .random(), author: owner, photos: Array(photos.shuffled().prefix(Int.random(in: 1 ... 5)))),
        .init(id: .random(), author: Friend.random(1).first!, photos: Array(photos.shuffled().prefix(Int.random(in: 1 ... 5)))),
      ]
    )
  }

  private func getDate(offset: Int) -> Date {
    Calendar.current.date(byAdding: .day, value: -offset, to: .now) ?? .now
  }

  // MARK: - State

  @MainActor
  private func stateLoading() async {
    state = .loading
  }

  @MainActor
  private func stateLoaded(_ value: [Journal]) async {
    state = .loaded(value)
  }

  @MainActor
  private func stateError() async {
    state = .error
  }
}

extension ProfileViewModel {
  enum State {
    case loading
    case loaded([Journal])
    case error
  }
}
