import SwiftUI
import VisionKit

class ProductViewModel: ObservableObject {
    @Published var ingredients: String?

    func fetchProductInfo(barcode: String) {
        // Construct the URL for the Open Food Facts API endpoint
        let baseURL = "https://world.openfoodfacts.org/api/v0/product/"
        let urlString = baseURL + barcode + ".json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Create a URLSession object
        let session = URLSession.shared

        // Create a data task for the URL
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check if a response was received
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            // Check if data was returned
            guard let responseData = data else {
                print("No data returned")
                return
            }

            do {
                // Parse the JSON response
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String: Any]

                // Check if product exists in the response
                if let product = json["product"] as? [String: Any] {
                    // Check if ingredients exist in the product
                    if let ingredients = product["ingredients_text"] as? String {
                        DispatchQueue.main.async {
                            self.ingredients = ingredients
                        }
                    } else {
                        print("Ingredients not found")
                    }
                } else {
                    print("Product information not found")
                }

            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

struct ContentView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var harmfulDict: [String] = [] // Array to store lines from the text file
    @State private var isTextFileRead = false // Flag to track if the text file has been read
    @State private var recognizedItems: [RecognizedItem] = []

    var body: some View {
        
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
        
        VStack {
            if !isTextFileRead {
                Text("Loading...")
                    .onAppear {
                        readTextFile()
                    }
            } else {
                if let ingredients = viewModel.ingredients {
                    let ingredientsArray = ingredients.lowercased().components(separatedBy: ", ")

                    if !ingredientsArray.isEmpty {
                        Text("Ingredients: \(ingredientsArray.joined(separator: ", "))")
                    } else {
                        Text("No harmful ingredients found")
                    }
                } else {
                    Text("Loading...")
                        .onAppear {
                            
                            let barcode = "0049000042566"
                            viewModel.fetchProductInfo(barcode: barcode)
                        }
                }
            }
        }
        .padding()
    }

    func readTextFile() {
        // Read from txt file and add to list
        if let filePath = Bundle.main.path(forResource: "Harmful_Products", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                harmfulDict = content.components(separatedBy: .newlines).map { $0.lowercased() }
                isTextFileRead = true

                for line in harmfulDict {
                    print(line)
                }
            } catch {
                print("Error reading text file: \(error.localizedDescription)")
            }
        } else {
            print("Text file not found.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
