//
//  UnsplashService.swift
//  Voonew
//
//  Created by Tom on 13/04/2024.
//

import Foundation

final class UnsplashService {

  private let apiKey: String
  private let baseURL: String = "https://api.unsplash.com"
  private lazy var requestHeaders: [String: String] = [
    "Accept-Version": "v1",
    "Authorization": "Client-ID \(apiKey)"
  ]

  private let decoder = JSONDecoder()

  init(apiKey: String) {
    self.apiKey = apiKey
  }


  func random() async throws -> [UnsplashPhoto] {
    try await random(1)
  }

  func random(_ count: Int) async throws -> [UnsplashPhoto] {
    guard let request = makeRequest(for: .random, queryItems: ["count": String(count)]) else {
      throw Failure.invalidRequest
    }

    let (rawData, _) = try await URLSession.shared.data(for: request)
    let unsplashData = try decoder.decode([UnsplashPhoto].self, from: rawData)
    return unsplashData
  }

  private func makeRequest(for endpoint: Endpoint, queryItems: [String: String] = [:]) -> URLRequest? {
    guard let url = URL(string: baseURL)?.appending(path: endpoint.path) else {
      return nil
    }

    let urlWithQueryParameters = url.appending(
      queryItems: queryItems.map { .init(name: $0, value: $1) }
    )

    var request = URLRequest(url: urlWithQueryParameters)
    request.allHTTPHeaderFields = requestHeaders
    return request
  }
}

private extension UnsplashService {
  enum Endpoint {
    case random

    var path: String {
      switch self {
      case .random:
        "/photos/random"
      }
    }
  }

  enum Failure: Error {
    case invalidRequest
  }
}
