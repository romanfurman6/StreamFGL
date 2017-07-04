//
//  SettingsViewModel.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

protocol SettingsViewModelProtocol {
    var modelSelected: PublishSubject<Setting> { get }
    var settings: Observable<[Setting]> { get }
    var showAlertView: Observable<Void> { get }
    var showPickerView: Observable<Void> { get }
    var doneButtonTaps: PublishSubject<Void> { get }
    var streamCode: PublishSubject<String> { get }
    var streamService: StreamServiceProtocol { get }
}

class SettingsViewModel: SettingsViewModelProtocol {
    let modelSelected = PublishSubject<Setting>()
    let settings: Observable<[Setting]>
    let showAlertView: Observable<Void>
    let showPickerView: Observable<Void>
    let doneButtonTaps = PublishSubject<Void>()
    let streamCode = PublishSubject<String>()
    let streamService: StreamServiceProtocol

    init(streamSetvice: StreamServiceProtocol) {

        let settings = [
            Setting(description: "Set stream code"),
            Setting(description: "Choose stream quality")
        ]

        let showAlert = modelSelected.asObservable()
            .filter { $0 == settings[0] }
            .map { _ in }

        let showPicker = modelSelected.asObservable()
            .filter { $0 == settings[1] }
            .map { _ in }

        self.showAlertView = showAlert
        self.showPickerView = showPicker
        self.settings = Observable.just(settings)
        self.streamService = streamSetvice
    }
}
