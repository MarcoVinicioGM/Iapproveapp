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
            VStack {
                DataScannerView(recognizedItems: $recognizedItems, recognizesMultipleItems: true)
                    .navigationBarTitle("Barcode Scanner")
                
                Spacer()
                
                List(recognizedItems, id:\.id) { item in
                    if case let .barcode(barcode) = item {
                        Text(barcode.payloadStringValue ?? "Barcode not found")
                    }
                }
            }
        }
        .onAppear {
            print("Recognized Items: \(recognizedItems)")
        }
    }
}


