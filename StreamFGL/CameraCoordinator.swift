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

        self.navigationController.pushViewController(viewController, animated: true)
    }

    func finish() {}
}
