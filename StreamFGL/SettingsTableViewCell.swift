//
//  SettingsTableViewCell.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation
import RxSwift

final class SettingsTableViewCell: UITableViewCell, NibInitializable, ReusableCell {

    @IBOutlet weak var settingName: UILabel!

    func configure(with type: AlertType) {
        self.settingName.text = type.rawValue
    }
    
}
