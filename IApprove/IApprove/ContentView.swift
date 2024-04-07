//
//  ContentView.swift
//  IApprove
//
//  Created by Muhanad Yennes on 4/6/24.
//

import SwiftUI
import VisionKit
    
    struct ContentView: View {
        @State private var capturedImage: UIImage? = nil
        @State private var isCustomCameraViewPresented = false
        
        @State private var recognizedItems: [RecognizedItem] = []

        var body: some View {
            NavigationView {
                DataScannerView(recognizedItems: $recognizedItems, recognizesMultipleItems: true)
                    .navigationBarTitle("Barcode Scanner")
            }
        }
    }

    struct ContentView_Previews: PreviewProvider{
        static var previews: some View{
            ContentView()
        }
    }

