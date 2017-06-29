//
//  CameraViewController.swift
//  StreamFGL
//
//  Created by Roman Furman on 6/29/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import LFLiveKit

final class CameraViewController: UIViewController, StoryboardInitializable {

    var viewModel: CameraViewModelProtocol!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    private let disposeBag = DisposeBag()

    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .high3)

        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.containerView
        return session
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        session.running = trues
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.running = false
    }

    private func bindView() {

        settingsButton.rx.tap
            .bind(to: viewModel.settingsButtonTaps)
            .disposed(by: disposeBag)

        startButton.rx.tap
            .bind(onNext: startButtonTaps)
            .disposed(by: disposeBag)

        stopButton.rx.tap
            .bind(onNext: stopButtonTaps)
            .disposed(by: disposeBag)

    }

    private func startButtonTaps() {
        let stream = LFLiveStreamInfo()
        stream.url = Constant.shared.streamURL
        session.startLive(stream)
        startButton.isHidden = true
        stopButton.isHidden = false
    }

    private func stopButtonTaps() {
        session.stopLive()
        stopButton.isHidden = true
        startButton.isHidden = false
    }

}

extension CameraViewController: LFLiveSessionDelegate {

    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .error:
            print("===error===")
        case .pending:
            print("===pending===")
        case .ready:
            print("===ready===")
        case.start:
            print("===start===")
        case.stop:
            print("===stop===")
        case .refresh:
            print("===refresh===")
        }
    }

    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {

    }

    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error: \(errorCode)")
    }
}
