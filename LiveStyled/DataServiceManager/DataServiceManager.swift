//
//  DataServiceManager.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation


protocol NetworkManagerProtocol {
  /**
   Retrieves a list of event  by making an API call

   - parameters:

   - pageNumber: current page number to download through API
   - success: Closure to be executed upon successful API call
   - failure: Closure to be executed upon failure on  API call
   */
  func getEventList(with pageNumber:Int, success: @escaping (_ events: EventList) -> (), failure: @escaping (_ error: LiveStyledError) -> ())

}

protocol StorageManagerProtocol{
  /**
   Save the favourite button status for each event

   - parameters:

   - event: Pass the event details which user has checked or unchecked
   */
  func saveEventStatus(for event: Event)

  /**
   Retreive the list of event ID which user has added to Favourite

   - returns: a list of event ID which user has added to favourite
   */
  func getAllEventsFromStorage() -> [String]
}

protocol DataServiceManagerProtocol : NetworkManagerProtocol, StorageManagerProtocol {
}

public struct DataServiceManager {

  // API handler to perform all API calls
  private let apiHandler: APIHandlerProtocol

  // Storage handler to store the event info persistently
  private let storageHandler: StorageHandlerProtocol

  /**
   Creates a manager to customise Event list

   - parameters:

   - apiHandler: Handles API call to retreive Event list
   - storageHandler:  Handles mechanism for storing favourite event status
   */
  init(apiHandler: APIHandlerProtocol = APIHandler(), storageHandler: StorageHandlerProtocol = StorageHandler()) {
    self.apiHandler = apiHandler
    self.storageHandler = storageHandler
  }
}

// MARK: - DataServiceManagerProtocol Implementation -
extension DataServiceManager: DataServiceManagerProtocol {

  func getEventList(with pageNumber:Int, success: @escaping (_ events: EventList) -> (), failure: @escaping (_ error: LiveStyledError) -> ()) {
    guard let endpoint = Config.baseURLStr.prepareURL(with: APIEndpoint.events)
      else {
        failure(.configurationError(details: "Configuration Error - Bad URL"))
        return
    }
    self.apiHandler.fetchJSONData(with: endpoint, page: pageNumber)  { (result: RequestResult<EventList>) in
      switch result {
      case .success(item: let events):
        success(events)
      case .failure(let error):
        failure(error)
      }
    }
  }

  func saveEventStatus(for event: Event) {
    storageHandler.updateEventStatus(for: event)
  }

  func getAllEventsFromStorage() -> [String] {
    return storageHandler.getSavedEvents()
  }
  
}

