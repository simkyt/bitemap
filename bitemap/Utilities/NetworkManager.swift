//
//  NetworkManager.swift
//  bitemap
//
//  Created by Simonas Kytra on 27/11/2023.
//

import Foundation
import SwiftUI

class NetworkManager {
    
    static func fetchFoodFromDatabase(food: String, completion: @escaping ([DBFood]) -> () ) {
        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/foods?search=\(food)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMTUxMjI5NywianRpIjoiMjUzMjkzMjYtOTZmZC00YzM1LTlmYTQtMjJiMGY5OGFiMzExIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6eyJ1c2VySWQiOiJjNjUzNDZlMy0wMGJlLTQwYWYtYTdjOC1jY2FhNGEyZDY0MmQiLCJuYW1lIjoic2lta3l0In0sIm5iZiI6MTcwMTUxMjI5NywiZXhwIjoxNzAxNTk4Njk3LCJpc3MiOiJzaW1reXQiLCJhdWQiOiJUcnVzdGVkQ2xpZW50Iiwicm9sZXMiOlsidXNlciJdfQ.0zWAPZBzkYfTL1W0ZYTbymzdj-vhTFBgkIMujf-Tb80", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
            
            guard err == nil else {
                print("Error: ", err!)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode([DBFood].self, from: data)
                completion(jsonData)
            } catch{
                print("Error: ", error)
            }
        }.resume()
    }
    
    static func fetchFoodFromFS(food: String, completion: @escaping (FS) -> () ) {
        guard let url = URL(string: "https://platform.fatsecret.com/rest/server.api?method=foods.search&search_expression=\(food)&format=json&page_number=0&max_results=30") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4NDUzNUJFOUI2REY5QzM3M0VDNUNBRTRGMEJFNUE2QTk3REQ3QkMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJTRVUxdnB0dC1jTno3Rnl1VHd2bHBxbDkxN3cifQ.eyJuYmYiOjE3MDE1MzEzMzYsImV4cCI6MTcwMTYxNzczNiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiI3ZGMwOTc1MGJlNjY0OGRjYjNmMDc3ZmQ0N2JjMGZlNSIsInNjb3BlIjpbImJhc2ljIl19.IuxDcG0WnmYHnshj3PPBZAsK7dNyCU2OwLw1kYQWRMnfmq49KAlTKNAh8kIa0PeHnlL6yofpuOkwflZhV5Q1Z6cGfcTxJMjKcIkIg-P3XPYCoJMuZCqKoG6p5n4hbsvPox7EhEMsgLK5xuZH1WgW5PEatv8tuAyatHeE8uu0vIhcQzOKIRLbDpi7G2NLHM40F896SyE_UbLgQvEPEOWK2CAZZjwbDBa6fEcu4BNmcPn8IN0HLVQpMk4Cny7gIR-KqU9Qsx0l_sopxStR7S1KtqUB7zKTJVLXVyR26KySy1gZp4e4msxP3GNj7zABtFA_AOQgufbXYniH-DrV3fUMwQ", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
            
            guard err == nil else {
                print("Error: ", err!)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(FS.self, from: data)
                completion(jsonData)
            } catch{
                print("Error: ", error)
            }
        }.resume()
    }
    
//    static func fetchCategoriesFromDatabase(completion: @escaping ([DBCategory]) -> () ) {
//        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMTEwNTMwMywianRpIjoiZTQzOTE2NDgtZTZjYi00YTg2LWJmZmQtMzBiMzk4OTIxYTVmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6eyJ1c2VySWQiOiJjNjUzNDZlMy0wMGJlLTQwYWYtYTdjOC1jY2FhNGEyZDY0MmQiLCJuYW1lIjoic2lta3l0In0sIm5iZiI6MTcwMTEwNTMwMywiZXhwIjoxNzAxMTkxNzAzLCJpc3MiOiJzaW1reXQiLCJhdWQiOiJUcnVzdGVkQ2xpZW50Iiwicm9sZXMiOlsidXNlciJdfQ.3fq_lcJKmVtoNrCAEbG3vSM3k6uzUCCXbZYgvUmZYGM", forHTTPHeaderField: "Authorization")
//        
//        let config = URLSessionConfiguration.default
//        config.waitsForConnectivity = true
//        
//        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
//            
//            guard err == nil else {
//                print("Error: ", err!)
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                let jsonData = try JSONDecoder().decode([DBCategory].self, from: data)
//                completion(jsonData)
//            } catch{
//                print("Error: ", error)
//            }
//        }.resume()
//    }
//    
//    static func fetchSubcategoriesFromDatabase(id: Int, completion: @escaping ([DBSubcategory]) -> () ) {
//        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(id)/subcategories") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMTEwNTMwMywianRpIjoiZTQzOTE2NDgtZTZjYi00YTg2LWJmZmQtMzBiMzk4OTIxYTVmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6eyJ1c2VySWQiOiJjNjUzNDZlMy0wMGJlLTQwYWYtYTdjOC1jY2FhNGEyZDY0MmQiLCJuYW1lIjoic2lta3l0In0sIm5iZiI6MTcwMTEwNTMwMywiZXhwIjoxNzAxMTkxNzAzLCJpc3MiOiJzaW1reXQiLCJhdWQiOiJUcnVzdGVkQ2xpZW50Iiwicm9sZXMiOlsidXNlciJdfQ.3fq_lcJKmVtoNrCAEbG3vSM3k6uzUCCXbZYgvUmZYGM", forHTTPHeaderField: "Authorization")
//        
//        let config = URLSessionConfiguration.default
//        config.waitsForConnectivity = true
//        
//        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
//            
//            guard err == nil else {
//                print("Error: ", err!)
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                let jsonData = try JSONDecoder().decode([DBSubcategory].self, from: data)
//                completion(jsonData)
//            } catch{
//                print("Error: ", error)
//            }
//        }.resume()
//    }
//    
//    static func fetchSubcategoryFromDatabase(categoryId: Int, subcategoryId: Int, completion: @escaping (DBSubcategory) -> () ) {
//        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(categoryId)/subcategories/\(subcategoryId)") else { return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMTEwNTMwMywianRpIjoiZTQzOTE2NDgtZTZjYi00YTg2LWJmZmQtMzBiMzk4OTIxYTVmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6eyJ1c2VySWQiOiJjNjUzNDZlMy0wMGJlLTQwYWYtYTdjOC1jY2FhNGEyZDY0MmQiLCJuYW1lIjoic2lta3l0In0sIm5iZiI6MTcwMTEwNTMwMywiZXhwIjoxNzAxMTkxNzAzLCJpc3MiOiJzaW1reXQiLCJhdWQiOiJUcnVzdGVkQ2xpZW50Iiwicm9sZXMiOlsidXNlciJdfQ.3fq_lcJKmVtoNrCAEbG3vSM3k6uzUCCXbZYgvUmZYGM", forHTTPHeaderField: "Authorization")
//        
//        let config = URLSessionConfiguration.default
//        config.waitsForConnectivity = true
//        
//        URLSession(configuration: config).dataTask(with: request) { (data, response, err ) in
//            
//            guard err == nil else {
//                print("Error: ", err!)
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do {
//                let jsonData = try JSONDecoder().decode(DBSubcategory.self, from: data)
//                completion(jsonData)
//            } catch{
//                print("Error: ", error)
//            }
//        }.resume()
//    }
    
    static func postFoodToDatabase(categoryId: Int, subcategoryId: Int, food: Food) {
        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(categoryId)/subcategories/\(subcategoryId)/foods") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMTUxMjI5NywianRpIjoiMjUzMjkzMjYtOTZmZC00YzM1LTlmYTQtMjJiMGY5OGFiMzExIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6eyJ1c2VySWQiOiJjNjUzNDZlMy0wMGJlLTQwYWYtYTdjOC1jY2FhNGEyZDY0MmQiLCJuYW1lIjoic2lta3l0In0sIm5iZiI6MTcwMTUxMjI5NywiZXhwIjoxNzAxNTk4Njk3LCJpc3MiOiJzaW1reXQiLCJhdWQiOiJUcnVzdGVkQ2xpZW50Iiwicm9sZXMiOlsidXNlciJdfQ.0zWAPZBzkYfTL1W0ZYTbymzdj-vhTFBgkIMujf-Tb80", forHTTPHeaderField: "Authorization")

        let foodDetails: [String: Any] = [
            "id": food.id!.uuidString,
            "name": food.name ?? "",
            "brand": food.brand ?? "",
            "kcal": food.kcal,
            "carbs": food.carbs,
            "fat": food.fat,
            "protein": food.protein,
            "serving": food.serving ?? "",
            "perserving": food.perserving ?? "",
            "size": food.size
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: foodDetails, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making POST request: \(error.localizedDescription)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 201 {
                    print("HTTP Request failed with status code: \(httpResponse.statusCode)")
                    return
                }
                print("Food item posted successfully")
            }
            task.resume()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func updateFoodInDatabase(categoryId: Int, subcategoryId: Int, _ dbFood: DBFood) {
        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(categoryId)/subcategories/\(subcategoryId)/foods/\(dbFood.id)") else {
            print("Invalid URL")
            return
        }
        
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcwMTUxMjI5NywianRpIjoiMjUzMjkzMjYtOTZmZC00YzM1LTlmYTQtMjJiMGY5OGFiMzExIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6eyJ1c2VySWQiOiJjNjUzNDZlMy0wMGJlLTQwYWYtYTdjOC1jY2FhNGEyZDY0MmQiLCJuYW1lIjoic2lta3l0In0sIm5iZiI6MTcwMTUxMjI5NywiZXhwIjoxNzAxNTk4Njk3LCJpc3MiOiJzaW1reXQiLCJhdWQiOiJUcnVzdGVkQ2xpZW50Iiwicm9sZXMiOlsidXNlciJdfQ.0zWAPZBzkYfTL1W0ZYTbymzdj-vhTFBgkIMujf-Tb80", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(dbFood)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making PUT request: \(error.localizedDescription)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        print("HTTP Request failed with status code: \(httpResponse.statusCode)")
                        
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response from the server: \(responseString)")
                        }
                    } else {
                        print("Food item updated successfully")
                    }
                }
            }
            task.resume()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
