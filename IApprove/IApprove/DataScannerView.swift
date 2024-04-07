import Foundation
import SwiftUI
import VisionKit

//Main workhorse for camera sacanning, implements Visionkit framework
// to represent a UIViewController in SwiftUI
struct DataScannerView: UIViewControllerRepresentable {
    //Array of objects causing issues with barcode String implementation
        //Cause for complications with cross labeling
    @Binding var recognizedItems: [RecognizedItem]
    let recognizesMultipleItems: Bool

    //Most of code below is based off of Xcoding with Alfian YT
    //This controller specifically is responsible for barcode scans
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: recognizesMultipleItems,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    //Will create coord instance to act as delegate for Data Scanner View Controller
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItems: $recognizedItems)
    }
    //Deallocates uiViewController
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    // All based around DataScannerViweControllerDelegate protocol to handle events
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedItems: [RecognizedItem]
        @Binding var barcodeItem: [String]

        init(recognizedItems: Binding<[RecognizedItem]>) {
            self._recognizedItems = recognizedItems
        }
        // Following functions is called when user taps on item or just when new items are recognized depending on scalability
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            print("didTapOn \(item)")
            barcodeItem = item
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            recognizedItems.append(contentsOf: addedItems)
            print("didAddItems \(addedItems)")
        }
    }
}
