//
//  SettingsTableViewCell.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import Foundation

final class SettingsTableViewCell: UITableViewCell, NibInitializable, ReusableCell {

    @IBOutlet weak var settingName: UILabel!

    func configure(with setting: Setting) {
        self.settingName.text = setting.description
    }
    
}
