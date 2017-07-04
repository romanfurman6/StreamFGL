//
//  CameraCoordinator.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

class CameraCoordinator: CoordinatorProtocol {

    var finished: Observable<Void> { return Observable.empty() }
    var stream = PublishSubject<Stream>()
    private var navigationController: UINavigationController
    private var settingsCoordinator: CoordinatorProtocol!
    private var disposeBag = DisposeBag()
    private var streamService: StreamServiceProtocol

    init(navigationController: UINavigationController, streamService: StreamServiceProtocol) {
        self.streamService = streamService
        self.navigationController = navigationController
    }

    func start() {
        let viewController = CameraViewController.initFromStoryboard()
        let viewModel = CameraViewModel(streamService: streamService)
        viewController.viewModel = viewModel

        viewModel.settingsButtonTaps
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.showSettings()
            })
            .disposed(by: disposeBag)

        viewController.rx.viewDidLoad
            .bind(onNext: { [weak self] _ in
                self?.streamService.startNewSession(on: viewController.containerView)
            })
            .disposed(by: disposeBag)

        viewController.rx.viewWillAppear
            .map { _ in true }
            .bind(onNext: { [weak self] value in
                self?.streamService.liveSession?.running = value
            })
            .disposed(by: disposeBag)

        viewController.rx.viewWillDisappear
            .map { _ in false }
            .bind(onNext: { [weak self] value in
                self?.streamService.liveSession?.running = value
            })
            .disposed(by: disposeBag)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func showSettings() {
        settingsCoordinator = SettingsCoordinator(
            navigationController: navigationController,
            streamService: streamService
        )

        settingsCoordinator.finished
            .subscribe(onNext: { [weak self] _ in
                self?.settingsCoordinator = nil
            })
            .disposed(by: disposeBag)

        settingsCoordinator.start()
    }

    func finish() {}
}
