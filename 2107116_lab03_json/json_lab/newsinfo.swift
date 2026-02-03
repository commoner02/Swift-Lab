//
//  newsinfo.swift
//  json_lab
//
//  Created by macos on 27/1/26.
//

import Foundation
// MARK: - CountryElement
struct CountryElement: Codable,Identifiable{
    var id:UUID { UUID()}
    let flags: Flags
    let name: Name
}

// MARK: - Flags
struct Flags: Codable {
    let png: String
    let svg: String
    let alt: String
}

// MARK: - Name
struct Name: Codable {
    let common, official: String
    let nativeName: [String: NativeName]
}

// MARK: - NativeName
struct NativeName: Codable {
    let official, common: String
}

struct APIResponse: Codable {
    var articles: [CountryElement]
}


import Foundation

class ArticleViewModel: ObservableObject {
    @Published var articles: [CountryElement] = [] // Observable array of articles
    @Published var isLoading: Bool = false // Loading indicator
    @Published var errorMessage: String? = nil // Error messages

    //private let apiKey = "ac3d3dcbcadb4f7cabca1f7f2b46f8af" // Replace with your News API key
    private let baseURL = "https://restcountries.com/v3.1/all?fields=name,flags"

    /// Fetch articles from News API
    func fetchArticles() {
        guard let url = URL(string: "\(baseURL)") else {
            self.errorMessage = "Invalid API URL."
            return
        }

        self.isLoading = true
        self.errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Failed to fetch articles: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received from the server."
                    return
                }

                do {
                    // Decode the JSON response into NewsResponse
                    let decodedResponse = try JSONDecoder().decode([CountryElement].self, from: data)
                    self.articles = decodedResponse
                } catch {
                    print("Failed to Decode articles: \(error)")
                    if let jsonString=String(data:data, encoding: .utf8)
                    {
                        print("received JSON: \(jsonString)")
                    }
                    DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode articles: \(error.localizedDescription)"
                    }
                    
                }
            }
        }.resume()
    }
}
