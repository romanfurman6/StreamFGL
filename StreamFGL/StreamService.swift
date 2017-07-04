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
    var streamCode: Variable<String> { get }
    var liveSession: LFLiveSession? { get }
}

final class StreamService: NSObject, StreamServiceProtocol {

    var liveSession: LFLiveSession?
    var streamCode = Variable<String>("")
    var videoQuality = Variable<LFLiveVideoQuality>(.high3)

    override init() {
        super.init()
    }

    func startNewSession(on view: UIView) {
        liveSession = LFLiveSession(
            audioConfiguration: LFLiveAudioConfiguration.defaultConfiguration(for: .default),
            videoConfiguration: LFLiveVideoConfiguration.defaultConfiguration(for: videoQuality.value)
        )

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
