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
    private var navigationController: UINavigationController
    private var settingsCoordinator: CoordinatorProtocol!
    private var disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = CameraViewController.initFromStoryboard()
        let viewModel = CameraViewModel()
        viewController.viewModel = viewModel

        viewModel.settingsButtonTaps
            .asObservable()
            .bind(onNext: showSettings)
            .disposed(by: disposeBag)

        self.navigationController.pushViewController(viewController, animated: true)
    }

    func finish() {}

    func showSettings() {
        settingsCoordinator = SettingsCoordinator(navigationController: self.navigationController)
        settingsCoordinator.start()
        settingsCoordinator.finished
            .subscribe(onNext: { [weak self] _ in
                self?.settingsCoordinator.finish()
                self?.settingsCoordinator = nil
            })
            .disposed(by: disposeBag)
    }
}
