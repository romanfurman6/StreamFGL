//
//  StreamService.swift
//  StreamFGL
//
//  Created by Roman Furman on 7/3/17.
//  Copyright © 2017 Roman Furman. All rights reserved.
//

import RxSwift
import RxCocoa
import LFLiveKit
import AVFoundation

protocol StreamServiceProtocol {
    func startNewSession(on view: UIView)
    func startLive()
    func stopLive()
    var videoQuality: Variable<LFLiveVideoQuality> { get }
    var audioQuality: Variable<LFLiveAudioQuality> { get }
    var streamCode: Variable<String> { get }
    var liveSession: LFLiveSession? { get }
    var createdNewSession: PublishSubject<Void> { get }
}

final class StreamService: NSObject, StreamServiceProtocol {

    var liveSession: LFLiveSession?
    var streamCode = Variable<String>("")
    var videoQuality = Variable<LFLiveVideoQuality>(.high3)
    var audioQuality = Variable<LFLiveAudioQuality>(.high)
    var createdNewSession = PublishSubject<Void>()
    private var disposeBag = DisposeBag()

    override init() {
        super.init()
        Observable.of(videoQuality.asObservable().map { _ in}, audioQuality.asObservable().map { _ in })
            .merge()
            .bind(onNext: createdNewSession.onNext)
            .disposed(by: disposeBag)
    }

    func startNewSession(on view: UIView) {
        liveSession = LFLiveSession(
            audioConfiguration: LFLiveAudioConfiguration.defaultConfiguration(for: audioQuality.value),
            videoConfiguration: LFLiveVideoConfiguration.defaultConfiguration(for: videoQuality.value)
        )

        liveSession?.adaptiveBitrate = true
        liveSession?.preView = view
        liveSession?.delegate = self
        liveSession?.captureDevicePosition = .back
    }

    func startLive() {
        let streamInfo = LFLiveStreamInfo()
        streamInfo.url = Constant.shared.streamURL + "/" + streamCode.value
        liveSession?.startLive(streamInfo)
    }

    func stopLive() {
        liveSession?.stopLive()
    }

}

extension StreamService: LFLiveSessionDelegate {

    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print(debugInfo?.description ?? "nil")
    }
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode)")
    }
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        var stateLabel = ""
        switch state {
        case LFLiveState.ready:
            stateLabel = "ready"
        case LFLiveState.pending:
            stateLabel = "pending"
        case LFLiveState.start:
            stateLabel = "start"
        case LFLiveState.error:
            stateLabel = "error"
        case LFLiveState.stop:
            stateLabel = "stop"
        default:
            break;
        }
        print(stateLabel)
    }
}
