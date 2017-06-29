//
//  CameraViewModel.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

protocol CameraViewModelProtocol {
    var settingsButtonTaps: PublishSubject<Void> { get }
}

class CameraViewModel: CameraViewModelProtocol {
    let settingsButtonTaps = PublishSubject<Void>()
}
