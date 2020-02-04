//
//  EventViewCell.swift
//  LiveStyled
//
//  Copyright © 2020 Ria Chandra. All rights reserved.
//

import UIKit
import SDWebImage

class EventListTableViewCell: UITableViewCell {

  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleILabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!

  typealias ToggleClosure = (Bool) -> Void
  var didToggle: ToggleClosure?

  var eventData: Event? {
    didSet {
      configureCell() // configure cell to popultae event list
      toggoleState()  // toggle the state of favourite on click event
    }
  }

  @IBAction func favoriteButtonClicked(_ sender: UIButton) {
    self.eventData?.isFavourite = !(self.eventData?.isFavourite ?? false)
    didToggle?(self.eventData?.isFavourite ?? false)
    toggoleState()
  }

  func toggoleState() {
    guard let event = eventData else {
      return
    }
    let title = event.isFavourite ? "Unfavourite" : "Favourite"
    favoriteButton.setTitle(title, for: .normal)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

}

private extension EventListTableViewCell {

  func configureCell() {
    titleILabel.text = eventData?.title
    subTitleLabel.text = eventData?.startDate?.convertDateToString()
    if let image = eventData?.image, let imageURL = URL(string: image) {
      iconImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder.png"))
      iconImageView.addCircle()
    }
  }

}
