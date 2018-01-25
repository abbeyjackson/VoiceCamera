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
    
    static func initializeSession() throws -> AVCaptureSession {
        return AVCaptureSession()
    }
    
    static func makeFrontCamera() throws -> AVCaptureDevice {
    
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .unspecified)
        
        guard !discoverySession.devices.isEmpty else { throw CameraControllerError.noCamerasAvailable }
        
        if let camera = discoverySession.devices.filter ({ $0.position == .front }).first {
            return camera
        } else {
            throw CameraControllerError.cameraNotAvailable(type: .front)
        }
    }
    
    static func makeRearCamera() throws -> AVCaptureDevice {
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: AVMediaType.video,
                                                                position: .unspecified)
        
        guard !discoverySession.devices.isEmpty else { throw CameraControllerError.noCamerasAvailable }
        
        if let camera = discoverySession.devices.filter ({ $0.position == .back }).first {
            return camera
        } else {
            throw CameraControllerError.cameraNotAvailable(type: .back)
        }
    }
    
    static func makeFrontCameraInput(from frontCamera: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        
        do {
            return try AVCaptureDeviceInput(device: frontCamera)
        } catch {
            throw CameraControllerError.invalidInput(type: .front)
        }
    }
    
    static func makeRearCameraInput(from rearCamera: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        
        do {
            return try AVCaptureDeviceInput(device: rearCamera)
        } catch {
            throw CameraControllerError.invalidInput(type: .back)
        }
    }
    
    static func addCameraInput(_ input: AVCaptureDeviceInput, to session: AVCaptureSession) throws {
        
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            throw CameraControllerError.cannotAddInput(input.device.position)
        }
    }
    
    static func makeOutput() throws -> AVCapturePhotoOutput {
        
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        return photoOutput
    }
    
    static func addOutput(_ output: AVCapturePhotoOutput, to session: AVCaptureSession) throws {
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            throw CameraControllerError.cannotAddOutput
        }
    }
}
