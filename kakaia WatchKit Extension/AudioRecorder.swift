//
//  AudioRecorder.swift
//  kakaia WatchKit Extension
//
//  Created by Jeremy Andrews on 12/29/19.
//  Copyright © 2019 Jeremy Andrews. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct KakaiaResponse: Decodable {
    let command: String
    let human: String
    let raw: String
    let result: Double

    init(command: String? = "none",
         human: String? = "empty",
         raw: String? = "",
         result: Double? = 0.0) {
        
        self.command = command!
        self.human = human!
        self.raw = raw!
        self.result = result!
    }
}

class AudioRecorder: ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recording = 0 {
        didSet {
            objectWillChange.send(self)
        }
    }
    var kakaia_response: KakaiaResponse = KakaiaResponse () {
        didSet {
            objectWillChange.send(self)
        }
    }
    var kakaia_error: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    var showErrorModal: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    var showTimerModal: Bool = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .spokenAudio)
            try recordingSession.setActive(true)
        } catch {
            print("Error: failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("audio.flac")
        
        // Kakaia engine requires 16,000 Hz mono recording
        let settings = [
            AVFormatIDKey: Int(kAudioFormatFLAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = 1
        } catch {
            print("Error: could not start recording")
        }
        
    }
    
    private var cancellable: AnyCancellable?

    
    func stopRecording() {
        audioRecorder.stop()
        recording = 2
        
        enum HTTPError: LocalizedError {
            case statusCode
        }
        
        enum KakaiaError: Error {
            case empty
            case detail(String)
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("audio.flac")
        do {
            let audioData = try Data(contentsOf: audioFilename)
            let encodedString = audioData.base64EncodedString()
            let dataString = encodedString.data(using: String.Encoding.utf8)
            
            // @TODO: this needs to be configurable, not hard coded
            guard let audioToTextUrl = URL(string: "http://10.10.200.126:8088/convert/audio/text") else {
                self.recording = 0
                self.kakaia_error = true
                self.showErrorModal = true
                self.kakaia_response = KakaiaResponse(raw: "Error: failed to create Kakaia engine URL")
                return
            }
            
            var sendAudioRequest = URLRequest(url: audioToTextUrl)
            sendAudioRequest.httpMethod = "POST"
            sendAudioRequest.httpBody = dataString
            self.cancellable = URLSession.shared.dataTaskPublisher(for: sendAudioRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        self.recording = 0
                        self.kakaia_error = true
                        self.showErrorModal = true
                        self.kakaia_response = KakaiaResponse(raw: "Error: failed to POST audio file to Kakaia engine")
                        throw KakaiaError.detail("Error: failed to POST audio to Kakaia engine")
                }
                return data
            }
            .receive(on: RunLoop.main)
            .decode(type: KakaiaResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let anError):
                        self.showErrorModal = true
                        self.kakaia_error = true
                        self.kakaia_response = KakaiaResponse(raw: "Error: " + String(describing: anError))
                        break
                }
                self.recording = 0
                if self.kakaia_response.result == 0.0 {
                    self.kakaia_error = true
                    self.showErrorModal = true
                    self.showTimerModal = false
                }
                else {
                    self.kakaia_error = false
                    self.showErrorModal = false
                    self.showTimerModal = true
                }
            }, receiveValue: { value in
                self.kakaia_response = value
            })
        } catch {
            self.kakaia_response = KakaiaResponse(raw: "Error: failed to parse audio file")
            self.showErrorModal = true
            self.kakaia_error = true
            self.recording = 0
        }
    }

}
