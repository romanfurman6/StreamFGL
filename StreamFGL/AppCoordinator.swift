//
//  AppCoordinator.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

class AppCoordinator: CoordinatorProtocol {

    var finished: Observable<Void> { return Observable.empty() }

    // MARK: - Private Properties
    private let window = UIWindow()
    private let navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    private let streamService: StreamServiceProtocol

    // MARK: - Child Coordinators
    private var cameraCoordinator: CoordinatorProtocol?

    init(streamService: StreamServiceProtocol) {
        self.streamService = streamService
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func start() {
        showCamera()
    }

    private func showCamera() {
        cameraCoordinator = CameraCoordinator(navigationController: navigationController, streamService: streamService)
        cameraCoordinator?.start()
    }

    func finish() {}
}
