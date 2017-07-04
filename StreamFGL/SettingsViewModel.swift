//
//  SettingsViewModel.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

enum AlertType: String {
    case code = "Stream code"
    case video = "Video quality"
    case audio = "Audio quality"
}

protocol SettingsViewModelProtocol {
    var modelSelected: PublishSubject<AlertType> { get }
    var settings: Observable<[AlertType]> { get }
    var showAlertView: Observable<AlertType> { get }
    var doneButtonTaps: PublishSubject<Void> { get }
    var streamCode: PublishSubject<String> { get }
    var streamService: StreamServiceProtocol { get }
}

class SettingsViewModel: SettingsViewModelProtocol {
    let modelSelected = PublishSubject<AlertType>()
    var settings: Observable<[AlertType]>
    let showAlertView: Observable<AlertType>
    let doneButtonTaps = PublishSubject<Void>()
    let streamCode = PublishSubject<String>()
    let streamService: StreamServiceProtocol

    init(streamSetvice: StreamServiceProtocol) {

        let settings: [AlertType] = [.code, .video, .audio]

        let showCodeAlert = modelSelected.asObservable()
            .filter { $0 == .code }

        let showVideoQuality = modelSelected.asObservable()
            .filter { $0 == .video }

        let showAudioQuality = modelSelected.asObservable()
            .filter { $0 == .audio }

        let showAlerView = Observable.of(showCodeAlert, showVideoQuality, showAudioQuality)
            .merge()

        self.showAlertView = showAlerView
        self.settings = Observable.just(settings)
        self.streamService = streamSetvice
    }
}
