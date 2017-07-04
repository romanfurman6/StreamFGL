//
//  AppDelegate.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/30/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: CoordinatorProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        startAppCoordinator()

        return true
    }

    private func startAppCoordinator() {
        let streamService = StreamService()
        appCoordinator = AppCoordinator(streamService: streamService)
        appCoordinator?.start()
    }

}
