//
//  SettingsCoordinator.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift
import LFLiveKit

class SettingsCoordinator: CoordinatorProtocol {

    var finished: Observable<Void> { return finishedSubject.asObservable() }
    var stream = PublishSubject<Stream>()
    private let finishedSubject = PublishSubject<Void>()
    private var navigationController: UINavigationController
    private var disposeBag = DisposeBag()
    private let streamService: StreamServiceProtocol

    init(navigationController: UINavigationController, streamService: StreamServiceProtocol) {
        self.streamService = streamService
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SettingsViewController.initFromStoryboard()
        let viewModel = SettingsViewModel(streamSetvice: streamService)
        viewController.viewModel = viewModel

        viewModel.doneButtonTaps
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.finish()
            })
            .disposed(by: disposeBag)

        self.navigationController.present(viewController, animated: true, completion: nil)
    }

    func finish() {
        self.navigationController.dismiss(animated: true, completion: nil)
        self.finishedSubject.onNext()
    }
}
