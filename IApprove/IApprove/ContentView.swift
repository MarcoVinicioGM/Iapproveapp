import SwiftUI
import VisionKit

struct ContentView: View {
    @State private var recognizedItems: [RecognizedItem] = []
    @State private var scannedBarcode: String? = nil

    var body: some View {
        NavigationView {
            VStack {
                DataScannerView(recognizedItems: $recognizedItems, recognizesMultipleItems: true) { recognizedItems in
                    for item in recognizedItems {
                        if case let .barcode(barcode) = item {
                            self.scannedBarcode = barcode.payloadStringValue ?? "Unknown barcode"
                        }
                    }
                }
                .navigationBarTitle("Barcode Scanner")
            }
            Text(scannedBarcode ?? "No barcode scanned")
        }
    }
}
