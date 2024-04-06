//
//  CustomCameraView.swift
//  IApprove
//
//  Created by Marco Garcia on 4/6/24.
//

import Foundation
import UIKit
import SwiftUI

struct CustomCameraView: View {
    let cameraService = CameraService()
    @Binding var capturedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View{
        ZStack{
            CameraView(cameraService: cameraService){ result in
                switch result{
                case.success(let photo):
                    if let data = photo.fileDataRepresentation(){
                        capturedImage = UIImage(data:data)
                    } else{
                        print("Error no image found")
                    }
                case.failure(let err):
                    print(err.localizedDescription)
                }
            }
            
            VStack{
                Spacer()
                Button(action: {
                    cameraService.capturePhoto()
                }, label: {
                    Image(systemName: "Circle")
                        .font(.system(size: 72))
                })
                .padding(.bottom)
            }
        }
    }
}
