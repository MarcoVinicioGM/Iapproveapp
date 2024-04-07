//
//  FoodAPI.swift
//  IApprove
//
//  Created by Muhanad Yennes on 4/6/24.
//
import Foundation

class OpenFoodFactsAPI {
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
                let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                print(json)
                // Process the JSON data to extract information about the product
                // You would typically extract relevant fields such as product name, ingredients, nutritional values, etc.
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        // Start the data task
        task.resume()
    }
}
