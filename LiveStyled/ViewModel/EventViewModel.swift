//
//  EventViewModel.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

protocol EventListProvider {
  var isLoadedList: Bool { get }
  var currentCount: Int { get }
  /**
   Get the list of events from server

   - parameters:

   - completionHandler - Returns a success or failure response as a result of network call
   */
  func getEventList(with completionHandler: @escaping (RequestResult<EventList>)  -> ())
  /**
   Get the event from event list

   - parameters:

   - index - pass the index of event list

   - returns:

   - Event - get the event data from event list
   */
  func event(at index: Int) -> Event

  /**
   Toggle the status of favourite button

   - parameters:

   - index - pass the index of event list

   - status - status to be set for button on user click
   */
  func toggleStatus(at index: Int, status: Bool)

  /**
   Get events from storage

   - returns:

   - returns a list of stored events
   */
  func getEventsFromStorage() -> [String]
}

final class EventViewModel {

  private var eventList: [Event] = [] // populate the list of events fetched through API call
  private var isFetchInProgress: Bool = false // check if event fetching is in progress
  private var currentPage: Int = 0 // Page number to fetch events from API
  private var totalPages: Int = -1
  // return the event list count
  var currentCount: Int {
    return eventList.count
  }

  // check if the complete list already loaded
  var isLoadedList: Bool {
    return self.currentCount == self.totalPages
  }

  let dataServiceManager: DataServiceManagerProtocol

  init(dataServiceManager: DataServiceManagerProtocol = DataServiceManager()) {
    self.dataServiceManager = dataServiceManager
  }

}

// MARK: - EventListProvider Implementation -
extension EventViewModel: EventListProvider {

  func getEventList(with completionHandler: @escaping (RequestResult<EventList>)  -> ()) {
    guard !isFetchInProgress else {
      return
    }
    self.isFetchInProgress = true
    dataServiceManager.getEventList(with: self.currentPage, success: { [weak self] (events) in
      guard let self = self else {
        return
      }
      guard let eventList = events.items else {
        completionHandler(.failure(error: .configurationError(details: "No event list")))
        return
      }
      self.eventList.append(contentsOf: eventList)
      self.updatePageCounter()
      self.totalPages = events.total ?? 0

      completionHandler(.success(item: events))
      }, failure: { error in
        switch error {
        case .configurationError(let configError):
          completionHandler(.failure(error: .configurationError(details: configError)))
        case .networkError(let networkError):
          completionHandler(.failure(error: .networkError(details: networkError)))
        case .parsingFailed(let parseError):
          completionHandler(.failure(error: .parsingFailed(details: parseError)))
        case .serverError(let serverError):
          completionHandler(.failure(error: .serverError(details:serverError)))
        }
    })
  }

  func getEventsFromStorage() -> [String] {
    return dataServiceManager.getAllEventsFromStorage()
  }
}

extension EventViewModel {

  // toggle button status when user clicks on Favourite button
  func toggleStatus(at index: Int, status: Bool) {
    eventList[index].isFavourite = status
    dataServiceManager.saveEventStatus(for: eventList[index])
  }

  // return event at index from event list
  func event(at index: Int) -> Event {
    return eventList[index]
  }

}

private extension EventViewModel {
  func updatePageCounter() {
    self.updateAllEventStatus()
    self.isFetchInProgress = false
    self.currentPage += 1
  }

  func updateAllEventStatus() {
    let favoriteEventList = self.getEventsFromStorage()
    for item in favoriteEventList {
      if let index = self.eventList.firstIndex(where: { $0.id == item }) {
        self.eventList[index].isFavourite = true
      }
    }
  }
}
