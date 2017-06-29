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
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    private let disposeBag = DisposeBag()
    private var streamCode = ""

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
        session.running = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert()
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.running = false
    }

    private func bindView() {

        startButton.rx.tap
            .bind(onNext: startButtonTaps)
            .disposed(by: disposeBag)

        stopButton.rx.tap
            .bind(onNext: stopButtonTaps)
            .disposed(by: disposeBag)

    }

    private func startButtonTaps() {
        if streamCode.isEmpty {
            showAlert()
            return
        }
        let stream = LFLiveStreamInfo()
        stream.url = "\(Constant.shared.streamURL)/\(streamCode)"
        session.startLive(stream)
        startButton.isHidden = true
        stopButton.isHidden = false
    }

    private func stopButtonTaps() {
        session.stopLive()
        stopButton.isHidden = true
        startButton.isHidden = false
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "Stream Code", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Type here your stream code."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak self] alert in
            guard let text = alertController.textFields?.first?.text else { return }
            self?.streamCode = text
        }))
        self.present(alertController, animated: true, completion:nil)
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
