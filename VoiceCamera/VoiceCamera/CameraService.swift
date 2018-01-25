//
//  CameraService.swift
//  VoiceCamera
//
//  Created by Abbey Jackson on 2018-01-24.
//  Copyright © 2018 FineARTech. All rights reserved.
//
//  Credit: Much of the set up for this controller class comes from AppCoda

import UIKit
import AVFoundation

class CameraService {
    
    public enum CameraPosition {
        case front
        case rear
    }
    
    var session: AVCaptureSession?
    
    var rearCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    var rearCameraInput: AVCaptureDeviceInput?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?

    func configureSession(completion: @escaping (Error?) -> Void) {
        
        DispatchQueue(label: "configure session").async {
            
            do {
                try self.initializeSession()
                try self.configureDevices()
                try self.configureInputs()
                try self.configureOutputs()
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    private func initializeSession() throws {
        
        session = AVCaptureSession()
    }
    
    private func configureDevices() throws {
    
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        
        guard !discoverySession.devices.isEmpty else { throw CameraControllerError.noCamerasAvailable }
        
        for camera in discoverySession.devices {
            if camera.position == .front {
                self.frontCamera = camera
            }
            if camera.position == .back {
                self.rearCamera = camera
                try camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
            }
        }
        
    }
    
    private func configureInputs() throws {
        guard let session = self.session else { throw CameraControllerError.captureSessionIsMissing }
        
        if let rearCamera = rearCamera {
            rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
        }
        if let rearCameraInput = rearCameraInput, session.canAddInput(rearCameraInput) {
            session.addInput(rearCameraInput)
            currentCameraPosition = .rear
        } else {
            if let frontCamera = frontCamera {
                frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            }
            if let frontCameraInput = frontCameraInput, session.canAddInput(frontCameraInput) {
                session.addInput(frontCameraInput)
                currentCameraPosition = .front
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
        }
    }
    
    private func configureOutputs() throws {
        guard let session = session else { throw CameraControllerError.captureSessionIsMissing }
        
        photoOutput = AVCapturePhotoOutput()
        if let photoOutput = photoOutput {
            photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            } else {
                throw CameraControllerError.outputsAreInvalid(reason: "Can not add session")
            }
            session.startRunning()
        } else {
            throw CameraControllerError.outputsAreInvalid(reason: "photoOutput is nil")
        }
    }
}
