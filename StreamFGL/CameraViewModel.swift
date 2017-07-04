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
    var streamService: StreamServiceProtocol { get }
    var streamCode:  BehaviorSubject<String> { get }
    var createdNewSession: PublishSubject<Void> { get }
}

class CameraViewModel: CameraViewModelProtocol {
    let settingsButtonTaps = PublishSubject<Void>()
    let streamService: StreamServiceProtocol
    var streamCode = BehaviorSubject<String>(value: "")
    var createdNewSession = PublishSubject<Void>()

    init(streamService: StreamServiceProtocol) {
        self.streamService = streamService
    }
}
