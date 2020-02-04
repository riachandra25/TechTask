//
//  String+Extension.swift
//  LiveStyled
//
//  Created by Ria Chandra on 04/02/2020.
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import Foundation

extension String {
  //convert string to url with endpoint
  func prepareURL(with endPoint: APIEndpoint) -> URL? {
    guard let endpoint = URL(string: self)
       else {
         return nil
     }
    return endpoint.appendingPathComponent(endPoint.rawValue)
  }
}
