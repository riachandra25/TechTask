//
//  EventViewModelTest.swift
//  LiveStyledTests
//
//  Created by Ria Chandra on 13/01/2020.
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import XCTest
@testable import LiveStyled

struct DynamicDataServiceManager: DataServiceManagerProtocol {

  let responseData: [Event]
  let networkError: Bool
  let serverError: Bool
  let configurationError: Bool
  let parsingFailed: Bool

  init(responseData:  [Event], networkError: Bool, serverError: Bool, configurationError: Bool, parsingFailed: Bool) {
    self.responseData = responseData
    self.networkError = networkError
    self.serverError = serverError
    self.configurationError = configurationError
    self.parsingFailed = parsingFailed
  }

  func getEventList(with pageNumber: Int, success: @escaping (EventList) -> (), failure: @escaping (LiveStyledError) -> ()) {
    if networkError {
      failure(.networkError(details: "Network Error"))
      return
    }
    if serverError {
      failure(.serverError(details: "Server Error"))
      return
    }
    if configurationError {
      failure(.configurationError(details: "Configuration Error"))
      return
    }

    if parsingFailed {
      failure(.parsingFailed(details: "Parsing Failed"))
      return
    }
    let event = Event(id: "5d4aab8bf28ea806fc721e1b", title: "Shelley Sanchez", image: "https://www.test.com", startDate: Date(), isFavorite: true)
    let responseData = EventList(page: 1, pageSize: 10, total: 20, items: [event])
    success(responseData)
  }

  func saveEventStatus(for event: Event) {
    print("Save event status")
  }

  func getAllEventsFromStorage() -> [String] {
    return ["id1", "id2"]
  }
}



class EventViewModelTest: XCTestCase {

  func testGetEventListNetworkError() {
    let mockDataServiceManager = DynamicDataServiceManager(responseData: [], networkError: true, serverError: false, configurationError: false, parsingFailed: false)
    let eventListViewModel: EventListProvider = EventViewModel(dataServiceManager: mockDataServiceManager)
    eventListViewModel.getEventList() { result in
      switch result {
      case .failure(let error):
        switch error {
        case .networkError(let details):
          XCTAssertEqual(details, "Network Error")
        default:
          XCTFail()
        }
      default:
        XCTFail()
      }
    }
  }

  func testGetEventListServerError() {
    let mockDataServiceManager = DynamicDataServiceManager(responseData: [], networkError: false, serverError: true, configurationError: false, parsingFailed: false)
    let eventListViewModel: EventListProvider = EventViewModel(dataServiceManager: mockDataServiceManager)
    eventListViewModel.getEventList() { result in
      switch result {
      case .failure(let error):
        switch error {
        case .serverError(let details):
          XCTAssertEqual(details, "Server Error")
        default:
          XCTFail()
        }
      default:
        XCTFail()
      }
    }
  }

  func testGetEventListConfigurationError() {
    let mockDataServiceManager = DynamicDataServiceManager(responseData: [], networkError: false, serverError: false, configurationError: true, parsingFailed: false)
    let eventListViewModel: EventListProvider = EventViewModel(dataServiceManager: mockDataServiceManager)
    eventListViewModel.getEventList() { result in
      switch result {
      case .failure(let error):
        switch error {
        case .configurationError(let details):
          XCTAssertEqual(details, "Configuration Error")
        default:
          XCTFail()
        }
      default:
        XCTFail()
      }

    }
  }

  func testGetEventListParsingError() {
    let mockDataServiceManager = DynamicDataServiceManager(responseData: [], networkError: false, serverError: false, configurationError: false, parsingFailed: true)
    let eventListViewModel: EventListProvider = EventViewModel(dataServiceManager: mockDataServiceManager)
    eventListViewModel.getEventList() { result in
      switch result {
      case .failure(let error):
        switch error {
        case .parsingFailed(let details):
          XCTAssertEqual(details, "Parsing Failed")
        default:
          XCTFail()
        }
      default:
        XCTFail()
      }
    }
  }

  func testGetEventListSuccess() {
    let mockDataServiceManager = DynamicDataServiceManager(responseData: [], networkError: false, serverError: false, configurationError: false, parsingFailed: false)
    let eventListViewModel: EventListProvider = EventViewModel(dataServiceManager: mockDataServiceManager)
    eventListViewModel.getEventList() { result in
      switch result {
      case .success(let result):
        let event = result.items?[0]
        XCTAssertEqual(result.items!.count, 1)
        XCTAssertEqual(event?.id, "5d4aab8bf28ea806fc721e1b")
        XCTAssertEqual(event?.title, "Shelley Sanchez")
        XCTAssertEqual(event?.image, "https://www.test.com")
      default:
        XCTFail()
      }
    }
  }

  func testEventCount() {
    let mockDataServiceManager = DynamicDataServiceManager(responseData: [], networkError: false, serverError: false, configurationError: false, parsingFailed: false)
    let eventListViewModel: EventListProvider = EventViewModel(dataServiceManager: mockDataServiceManager)
    let storedEventList = eventListViewModel.getEventsFromStorage()
    XCTAssertEqual(storedEventList.count, 2)
  }
}




