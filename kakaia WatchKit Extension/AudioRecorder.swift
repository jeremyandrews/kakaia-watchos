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

class AudioRecorder: ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recording = 0 {
        didSet {
            objectWillChange.send(self)
        }
    }
    var audio_as_text: String = "" {
        didSet {
            objectWillChange.send(self)
        }
    }
    var showModal: Bool = false {
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
            
            audio_as_text = ""
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
                self.audio_as_text = String("Error: failed to create Kakaia engine URL")
                return
            }
            
            var sendAudioRequest = URLRequest(url: audioToTextUrl)
            sendAudioRequest.httpMethod = "POST"
            sendAudioRequest.httpBody = dataString
            self.cancellable = URLSession.shared.dataTaskPublisher(for: sendAudioRequest)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        self.audio_as_text = String("Error: failed to POST audio file to Kakaia engine")
                        self.recording = 0
                        throw KakaiaError.detail("Error: failed to POST audio to Kakaia engine")
                }
                return data
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let anError):
                        self.audio_as_text = String("Error: " + String(describing: anError))
                        break
                }
                self.recording = 0
                self.showModal = true
            }, receiveValue: { value in
                self.audio_as_text = (String(data: value, encoding: .utf8))!
            })
        } catch {
            self.audio_as_text = String("Error: failed to parse audio file")
            self.recording = 0
        }
    }

}
