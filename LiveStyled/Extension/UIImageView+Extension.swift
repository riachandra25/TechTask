//
//  UIImageView+Extension.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import UIKit

extension UIImageView {

  // method to make image round
  func addCircle() {
    self.layer.cornerRadius = (self.frame.width / 2) 
    self.layer.masksToBounds = true
  }
}
