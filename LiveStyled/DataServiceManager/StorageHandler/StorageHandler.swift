//
//  StorageHandler.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//


import Foundation

protocol StorageHandlerProtocol {
  /**
   Save the updated event status in user default

   - parameters:

   - event: Store the event id when user clicks the favorite button,
   remove the event id when user unfavourite the event
   */
  func updateEventStatus(for event: Event)

  /**
   Fetch the list of event ID which is in user's favourite list

   - returns: A list of event ID which user has added to favourite
   */
  func getSavedEvents() -> [String]
}

// MARK: - StorageHandlerProtocol Implementation -
struct StorageHandler: StorageHandlerProtocol {
  
  func updateEventStatus(for event: Event) {
    save(event: event)
  }

  func getSavedEvents() -> [String] {
    return UserDefaultsConfig.savedEvents
  }
}

private extension StorageHandler {

  // Method to store/delete event id based on user click
  // on favourite button
  private func save(event: Event) {
    guard let id = event.id else{
      return
    }

    event.isFavourite ? UserDefaultsConfig.savedEvents.append(id) : UserDefaultsConfig.savedEvents.removeAll { $0 == id }
  }
}

