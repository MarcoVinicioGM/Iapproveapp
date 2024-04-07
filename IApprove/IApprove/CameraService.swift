//
//  CameraService.swift
//  IApprove
//
//  Created by Marco Garcia on 4/6/24.
//

import Foundation
import AVFoundation

class CameraService{
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func boot(delegate: AVCapturePhotoCaptureDelegate, completeion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPerm(completeion: completeion)
    }
    
    
    private func checkPerm(completeion: @escaping(Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ [weak self] granted in guard granted else {return}
            DispatchQueue.main.async {
                self?.setupCamera(completion: completeion)
            }
        }
        case .authorized:
            setupCamera(completion: completeion)
        case .restricted:
            print("THIS WILL NEVER BE PRINTED")
        case .denied:
            print("THIS WILL NEVER BE PRINTED")
        @unknown default:
            print("THIS WILL NEVER BE PRINTED")
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()){
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do{
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
                
            } catch{
                completion(error)
            }
        }
    }
}
