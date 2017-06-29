//
//  CoordinatorProtocol.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift

protocol CoordinatorProtocol {
    var finished: Observable<Void> { get }
    func start()
    func finish()
}
