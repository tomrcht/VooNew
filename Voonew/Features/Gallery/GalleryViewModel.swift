//
//  GalleryViewModel.swift
//  VoonewUITests
//
//  Created by Tom on 17/04/2024.
//

import Foundation

final class GalleryViewModel: ObservableObject {
  @Published private(set) var state: State = .loading
  @Published var selection: Set<Photo> = .init()

  private let unsplash = UnsplashService(apiKey: "8j7cdQS9HM1tfIomk_dUwqrIZ7wnymEECz6xk6OPP6k")

  func photos() async {
    await stateLoading()

    do {
//      let photos: [Photo] = Mocks.photos()
      let rawPhotos = try await unsplash.random(25)
      let photos = rawPhotos.map { Photo(from: $0) }
      await stateLoaded(photos)
    } catch {
      await stateError()
    }
  }

  func onTapPhoto(_ photo: Photo) {
    if selection.contains(photo) {
      selection.remove(photo)
    } else {
      selection.insert(photo)
    }
  }

  @MainActor
  private func stateLoading() async {
    state = .loading
  }

  @MainActor
  private func stateLoaded(_ value: [Photo]) async {
    state = .loaded(value)
  }

  @MainActor
  private func stateError() async {
    state = .error
  }
}

extension GalleryViewModel {
  enum State {
    case loading
    case loaded([Photo])
    case error
  }
}
