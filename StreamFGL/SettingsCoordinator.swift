//
//  SettingsCoordinator.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

class SettingsCoordinator: CoordinatorProtocol {

    var finished: Observable<Void> { return finishedSubject.asObservable() }
    private var finishedSubject = PublishSubject<Void>()
    private var navigationController: UINavigationController
    private var disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SettingsViewController.initFromStoryboard()
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func finish() {
        self.navigationController.popViewController(animated: true)
        finishedSubject.onNext()
    }
}
