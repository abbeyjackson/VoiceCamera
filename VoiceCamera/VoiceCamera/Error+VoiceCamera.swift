//
//  Error+VoiceCamera.swift
//  VoiceCamera
//
//  Created by Abbey Jackson on 2018-01-24.
//  Copyright © 2018 FineARTech. All rights reserved.
//

extension CameraService {
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case outputsAreInvalid(reason: String)
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
}
