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
    
    var audio_as_text = "" {
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
    
    func stopRecording() {
        audioRecorder.stop()
        recording = 2
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("audio.flac")
        do {
            let audioData = try Data(contentsOf: audioFilename)
            let encodedString = audioData.base64EncodedString()
            let dataString = encodedString.data(using: String.Encoding.utf8)
            
            // @TODO: this needs to be configurable, not hard coded
            guard let audioToTextUrl = URL(string: "http://10.10.200.126:8088/convert/audio/text") else {
                print("Error: failed to create URL")
                return
            }
            
            var sendAudioRequest = URLRequest(url: audioToTextUrl)
            sendAudioRequest.httpMethod = "POST"
            sendAudioRequest.httpBody = dataString
            let session = URLSession.shared
            let task = session.dataTask(with: sendAudioRequest) {
                (data, response, error) in
                guard error == nil else {
                    print("Error: failed to POST audio file to Kakaia engine")
                    print(error!)
                    return
                }
                guard let responseData = data else {
                    print("Error: no response from Kakaia engine")
                    return
                }
                self.audio_as_text = (String(data: responseData, encoding: .utf8))!
                self.recording = 0
            }
            task.resume()
        } catch {
            print("ERROR")
        }
    }

}
