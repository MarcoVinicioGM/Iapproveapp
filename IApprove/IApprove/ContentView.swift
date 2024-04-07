
import SwiftUI
import VisionKit

    
struct ContentView: View {
    
    @State private var barcodNumber: String
    @State private var recognizedItems: [RecognizedItem] = []
    
    var body: some View {
        NavigationView {
            VStack {
                //VisionKit handles barcode scanning
                DataScannerView(recognizedItems: $recognizedItems, recognizesMultipleItems: true)
                    .navigationBarTitle("Scan your barcode")
                
                Spacer()
                //Creates list view that displays recognized Items only barcodes
                List(recognizedItems, id: \.id) { item in
                    if case let .barcode(barcode) = item {
                        Text(barcode.payloadStringValue ?? "Unknown barcode")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .listStyle(PlainListStyle())
                .padding()
            }
        }
    }
}
