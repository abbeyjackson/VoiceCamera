//
//  Error+VoiceCamera.swift
//  VoiceCamera
//
//  Created by Abbey Jackson on 2018-01-24.
//  Copyright © 2018 FineARTech. All rights reserved.
//

import AVFoundation

extension CameraService {
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionNotRunning
        case invalidInput(type: AVCaptureDevice.Position)
        case cannotAddInput(AVCaptureDevice.Position)
        case outputsAreInvalid(reason: String)
        case cannotAddOutput
        case invalidOperation
        case cameraNotAvailable(type: AVCaptureDevice.Position)
        case noCamerasAvailable
        case unknown
    }
}
