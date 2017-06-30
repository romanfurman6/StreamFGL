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
    @IBOutlet weak var cameraPosition: UIButton!
    @IBOutlet weak var micActivation: UIButton!

    private let disposeBag = DisposeBag()
    private var streamCode = ""
    private var quality: LFLiveVideoQuality = .high3

    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: self.quality)

        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.containerView
        return session
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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

        micActivation.rx.tap
            .bind(onNext: micActivationButtonTaps)
            .disposed(by: disposeBag)

        cameraPosition.rx.tap
            .bind(onNext: cameraPositionButtonTaps)
            .disposed(by: disposeBag)
    }

    private func setupView() {
        startButton.layer.cornerRadius = 30
        stopButton.layer.cornerRadius = 30
        micActivation.layer.cornerRadius = 30
        cameraPosition.layer.cornerRadius = 30
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

    private func micActivationButtonTaps() {
        if session.muted {
            session.muted = false
            micActivation.setTitle("Mic On", for: .normal)
        } else {
            session.muted = true
            micActivation.setTitle("Mic Off", for: .normal)
        }
    }

    private func cameraPositionButtonTaps() {

        if session.captureDevicePosition == .back {
            session.captureDevicePosition = .front
            cameraPosition.setTitle("Front", for: .normal)
        } else {
            session.captureDevicePosition = .back
            cameraPosition.setTitle("Back", for: .normal)
        }
    }

    private func showAlert() {
        let alertController = UIAlertController(title: "Stream Code", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Type here your stream code."
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] alert in
            guard let text = alertController.textFields?.first?.text else { return }
            self?.streamCode = text
        }))
        self.present(alertController, animated: true, completion:nil)
    }

}

extension CameraViewController: LFLiveSessionDelegate {

}
