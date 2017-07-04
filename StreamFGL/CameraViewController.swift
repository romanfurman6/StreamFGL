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
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var recView: UIView!

    private let disposeBag = DisposeBag()
    private var isLive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.recView.backgroundColor = UIColor.gray
    }

    private func bindView() {

        let startButtonTaps = startButton.rx.tap
            .asObservable()
            .shareReplayLatestWhileConnected()

        startButtonTaps
            .withLatestFrom(viewModel.streamService.streamCode.asObservable())
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.streamService.startLive()
                self?.startButton.isHidden = true
                self?.stopButton.isHidden = false
                self?.isLive = true
                self?.startLive()
            })
            .disposed(by: disposeBag)

        startButtonTaps
            .withLatestFrom(viewModel.streamService.streamCode.asObservable())
            .filter { $0.isEmpty }
            .map { _ in }
            .subscribe(viewModel.settingsButtonTaps)
            .disposed(by: disposeBag)

        stopButton.rx.tap
            .asObservable()
            .bind(onNext: { [weak self] _ in
                self?.viewModel.streamService.stopLive()
                self?.startButton.isHidden = false
                self?.stopButton.isHidden = true
                self?.isLive = false
            })
            .disposed(by: disposeBag)

        micActivation.rx.tap
            .bind(onNext: { [weak self] _ in
                guard
                    let `self` = self,
                    let muted = self.viewModel.streamService.liveSession?.muted
                else { return }
                self.micActivation.backgroundColor = muted ? Color.micOnColor : Color.micOffColor
                let title = muted ? "Mic on" : "Mic off"
                self.micActivation.setTitle(title, for: .normal)
                self.viewModel.streamService.liveSession?.muted = muted ? false : true
            })
            .disposed(by: disposeBag)

        cameraPosition.rx.tap
            .bind(onNext: { [weak self] _ in
                let devicePosition = self?.viewModel.streamService.liveSession?.captureDevicePosition
                self?.viewModel.streamService.liveSession?.captureDevicePosition = (devicePosition == .back) ? .front : .back
            })
            .disposed(by: disposeBag)

        settingsButton.rx.tap
            .bind(to: viewModel.settingsButtonTaps)
            .disposed(by: disposeBag)
    }

    private func setupView() {
        startButton.layer.cornerRadius = 30
        stopButton.layer.cornerRadius = 30
        micActivation.layer.cornerRadius = 5
        cameraPosition.layer.cornerRadius = 5
        settingsButton.layer.cornerRadius = 5
        recView.layer.cornerRadius = 10
    }

    private func stopLive() {

    }

    func startLive() {
        let duration = 0.3
        UIView.animate(withDuration: duration, delay: 0.3, animations: {
            self.recView.backgroundColor = UIColor.gray
        }, completion: { _ in
            UIView.animate(withDuration: duration, delay: 0.3, animations: {
                self.recView.backgroundColor = UIColor.red
            }, completion: { _ in
                if self.isLive {
                    self.startLive()
                } else {
                    self.recView.backgroundColor = UIColor.gray
                }
            })
        })
    }

}
