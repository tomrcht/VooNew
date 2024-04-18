//
//  HomeViewModel.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

final class HomeViewModel: ObservableObject {

  // MARK: - Properties

  @Published private(set) var state: State = .loading
  private let date: Date = .now

  var formattedDate: String {
    dateFormatter.string(from: date)
  }

  private let unsplash = UnsplashService(apiKey: "8j7cdQS9HM1tfIomk_dUwqrIZ7wnymEECz6xk6OPP6k")

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
    return formatter
  }()

  // MARK: - Methods

  func journals() async {
    await stateLoading()

    do {
//      let photos: [Photo] = Mocks.photos()
      let rawPhotos = try await unsplash.random(25)
      let photos = rawPhotos.map { Photo(from: $0) }

      var journals: [Journal] = []
      for _ in 0 ... Int.random(in: 1...5) {
        journals.append(mockJournal(owner: Friend.random(1).first!, photos: photos))
      }
      await stateLoaded(journals)
    } catch {
      await stateError()
    }
  }

  private func mockJournal(owner: Friend, photos: [Photo]) -> Journal {
    Journal(
      id: .random(),
      date: date,
      owner: owner,
      name: Journal.mockName(),
      entries: [
        .init(id: .random(), author: owner, photos: Array(photos.shuffled().prefix(Int.random(in: 1 ... 5)))),
        .init(id: .random(), author: Friend.random(1).first!, photos: Array(photos.shuffled().prefix(Int.random(in: 1 ... 5)))),
      ]
    )
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

extension HomeViewModel {
  enum State {
    case loading
    case loaded([Journal])
    case error
  }
}
