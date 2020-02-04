//
//  APIHandler.swift
//  LiveStyled
//
//  Created by Ria Chandra on 11/01/2020.
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
  case GET
  case POST
  case PUT
  case DELETE
  case HEAD
  case CONNECT
  case TRACE
  case OPTIONS
}

protocol APIHandlerProtocol {
  /**
   Retrieves a list of event  by making an API call

   - parameters:

   - url: current page number to download through API
   - page:  current page number to download through API
   - completion: completion handler on success/failed API call
   */
  func fetchJSONData<T: Decodable>(with url: URL, page: Int, completion: @escaping (_ result: RequestResult<T>) -> ())
}

// MARK: - APIHandlerProtocol Implementation -
struct APIHandler: APIHandlerProtocol {

  // session to establish API calls
  private var session : URLSession

  init() {
    let config = URLSessionConfiguration.default
    self.session = URLSession(configuration: config)
  }

  func fetchJSONData<T: Decodable>(with url: URL, page: Int, completion: @escaping (_ result: RequestResult<T>) -> ()) {

    guard let componentURL = prepareComponentURL(url: url, currentPage: page)?.url else {
      completion(.failure(error: .configurationError(details: "Configuration Error - Bad URL")))
      return
    }

    let request = prepareRequest(for: componentURL, method: HTTPMethod.GET.rawValue)

    let task = self.session.dataTask(with: request) { data, response, error in
      if nil != error {
        completion(.failure(error: .networkError(details: "Network Error")))
        return
      }
      if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        // success case
        case 200...204:
          guard let validData = data else {
            completion(.failure(error: .configurationError(details: "Configuration Error")))
            return
          }
          do {
            // parse JSON response
            let decodableItem = try JSONDecoder().decode( T.self, from: validData)
            completion(.success(item: decodableItem))
          }
          catch _ {
            // parsing failed
            completion(.failure(error: .parsingFailed(details: "Parse Error")))
          }

        default:
          // failure
          completion(.failure(error: .serverError(details: "Server Error")))
        }
      }
    }
    task.resume()
  }
}

private extension APIHandler {

  // method to prepare the URLComponents with query items
  func prepareComponentURL(url: URL, currentPage: Int) -> URLComponents? {
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    var queryItems = [URLQueryItem]()
    let currencyQueryItem = URLQueryItem(name: "page", value: String(currentPage))
    queryItems.append(currencyQueryItem)
    components?.queryItems = queryItems
    return components
  }

  // method to prepare the URL request
  func prepareRequest(for url: URL, method: String) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method
    return request
  }
}
