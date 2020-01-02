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
            print("Failed to set up recording session")
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
            print("Could not start recording")
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
            let audioToTextUrl = URL(string: "http://10.10.200.126:8088/convert/audio/text")!
            var request = URLRequest(url: audioToTextUrl)
            request.httpMethod = "POST"
            request.httpBody = dataString
            
            var responseString = ""
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

                responseString = (String(data: data, encoding: .utf8))!
                self.audio_as_text = responseString
                self.recording = 0
            }
            task.resume()
        } catch {
            print("ERROR")
        }
    }

}
