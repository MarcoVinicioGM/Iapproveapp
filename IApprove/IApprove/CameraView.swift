//
//  CameraView.swift
//  IApprove
//
//  Created by Marco Garcia on 4/6/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let cameraService: CameraService
    let didFinishProcessingPhoto: (Result<AVCapturePhoto,Error> ) -> ()
    func makeUIViewController(context: Context) -> UIViewController {
        cameraService.boot(delegate: context.coordinator){err in
            if let err = err{
                didFinishProcessingPhoto(.failure(err))
            }
            return
        }
        
        let viewController = UIViewControllerType()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        cameraService.previewLayer.frame = viewController.view.bounds
        return viewController
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context:
                                Context){}
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        let parent: CameraView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto,Error> ) -> ()
        
        init(_ parent: CameraView,
             didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto,Error> ) -> ()){
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto
                         photo: AVCapturePhoto, error: Error?){
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
        }
    }
}
