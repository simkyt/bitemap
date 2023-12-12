//
//  NetworkManager.swift
//  bitemap
//
//  Created by Simonas Kytra on 27/11/2023.
//

import Foundation
import SwiftUI
import KeychainSwift

class NetworkManager {

    static func getCurrentAccessToken() -> String {
        let keychain = KeychainSwift()
        return keychain.get("accessToken") ?? ""
    }
    
    static func getCurrentRefreshToken() -> String {
        let keychain = KeychainSwift()
        return keychain.get("refreshToken") ?? ""
    }
    
    static func saveToken(accessToken: String, refreshToken: String) {
        let keychain = KeychainSwift()
        keychain.set(accessToken, forKey: "accessToken")
        keychain.set(refreshToken, forKey: "refreshToken")
    }
    
    static func reloginAndRetry(completion: @escaping () -> ()) {
        print("relogging")
        let loginUrl = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/login")!
        var request = URLRequest(url: loginUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginDetails = ["name": "simkyt", "password": "simkyt"]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: loginDetails)
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                        saveToken(accessToken: tokenResponse.access_token, refreshToken: tokenResponse.refresh_token)
                        completion() // retries whichever function was passed in
                    } catch {
                        print("Error decoding login response: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Login failed with response: \(response.debugDescription)")
            }
        }.resume()
    }
    
    static func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/accessToken") else { return completion(false) }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(getCurrentRefreshToken())", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error refreshing token: \(error!.localizedDescription)")
                return completion(false)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to refresh token: \(response.debugDescription)")
                return completion(false)
            }

            if let data = data {
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    saveToken(accessToken: tokenResponse.access_token, refreshToken: tokenResponse.refresh_token)
                    completion(true)
                } catch {
                    print("Error decoding token response: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }.resume()
    }
    
    static func fetchFoodFromDatabase(food: String, completion: @escaping ([BMFood]) -> ()) {
        let accessToken = getCurrentAccessToken()
        if accessToken.isEmpty {
            print("No access token available. Initiating re-login.")
            reloginAndRetry {
                fetchFoodFromDatabase(food: food, completion: completion)
            }
            return
        }
        
        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/foods?search=\(food)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(getCurrentAccessToken())", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: ", error!)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 401 {
                refreshAccessToken { success in
                    if success {
                        fetchFoodFromDatabase(food: food, completion: completion)
                    } else {
                        reloginAndRetry {
                            fetchFoodFromDatabase(food: food, completion: completion)
                        }
                    }
                }
            } else if let data = data {
                do {
                    let jsonData = try JSONDecoder().decode([BMFood].self, from: data)
                    completion(jsonData)
                } catch {
                    print("Error: ", error)
                }
            }
        }.resume()
    }
    
    static func fetchFoodFromFS(food: String, completion: @escaping (FS) -> () ) {
        guard let url = URL(string: "https://platform.fatsecret.com/rest/server.api?method=foods.search&search_expression=\(food)&format=json&page_number=0&max_results=20") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjQ4NDUzNUJFOUI2REY5QzM3M0VDNUNBRTRGMEJFNUE2QTk3REQ3QkMiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJTRVUxdnB0dC1jTno3Rnl1VHd2bHBxbDkxN3cifQ.eyJuYmYiOjE3MDIzOTk2OTYsImV4cCI6MTcwMjQ4NjA5NiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiI3ZGMwOTc1MGJlNjY0OGRjYjNmMDc3ZmQ0N2JjMGZlNSIsInNjb3BlIjpbImJhc2ljIl19.r_c3NAAjG-S3GzlT-yq9ZV4HKmGQS2HE4xig3C9oQ7OX5CQ6xlAY_cROw5zuFpiWONCLuzZ8VFbcwC3liMFb8v98hNegbhjQTdwMBzZ9z4S8O8SeAbm88EBLeiXS9IPULcb4wT2O7-wJrAurBiB-y6Bgsx_qM6Ud83XOLLhL8OMtaDtBzbWM0kt58zazL2uqO6yUianVFfocPrIGPLYwcZNQ6EGMcFn49ylhRqqIVmsylU_KV0mLajqdyd2owaYym_mAY_vgAuwWWU03xBYvtOdU8t9H7ysOKss_5_hmLOzJThoSrLz-nG-cBfUHbW2gkkN6d6cuUFYSqEpUq3XYag", forHTTPHeaderField: "Authorization")
        
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
    
    /// -UNUSED CALLS, decided to not use these as this data would realistically change very rarely and I wanted to avoid unneeded API calls, so instead just manually inserted it into the main bundle
    /// -In a launch app, if you needed to change the categories/subcategories and ensure they match in the database and in the app itself, you would probably just push an app update with the new data
    
//    static func fetchCategoriesFromDatabase(completion: @escaping ([DBCategory]) -> ()) {
//        let accessToken = getCurrentAccessToken()
//        if accessToken.isEmpty {
//            print("No access token available. Initiating re-login.")
//            reloginAndRetry {
//                fetchCategoriesFromDatabase(completion: completion)
//            }
//            return
//        }
//
//        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                print("Error: ", error!)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else { return }
//
//            if httpResponse.statusCode == 401 {
//                refreshAccessToken { success in
//                    if success {
//                        fetchCategoriesFromDatabase(completion: completion)
//                    } else {
//                        reloginAndRetry {
//                            fetchCategoriesFromDatabase(completion: completion)
//                        }
//                    }
//                }
//            } else if let data = data {
//                do {
//                    let jsonData = try JSONDecoder().decode([DBCategory].self, from: data)
//                    completion(jsonData)
//                } catch {
//                    print("Error: ", error)
//                }
//            }
//        }.resume()
//    }
//
//    static func fetchSubcategoriesFromDatabase(id: Int, completion: @escaping ([DBSubcategory]) -> ()) {
//        let accessToken = getCurrentAccessToken()
//        if accessToken.isEmpty {
//            print("No access token available. Initiating re-login.")
//            reloginAndRetry {
//                fetchSubcategoriesFromDatabase(id: id, completion: completion)
//            }
//            return
//        }
//
//        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(id)/subcategories") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                print("Error: ", error!)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else { return }
//
//            if httpResponse.statusCode == 401 {
//                refreshAccessToken { success in
//                    if success {
//                        fetchSubcategoriesFromDatabase(id: id, completion: completion)
//                    } else {
//                        reloginAndRetry {
//                            fetchSubcategoriesFromDatabase(id: id, completion: completion)
//                        }
//                    }
//                }
//            } else if let data = data {
//                do {
//                    let jsonData = try JSONDecoder().decode([DBSubcategory].self, from: data)
//                    completion(jsonData)
//                } catch {
//                    print("Error: ", error)
//                }
//            }
//        }.resume()
//    }
//
//    static func fetchSubcategoryFromDatabase(categoryId: Int, subcategoryId: Int, completion: @escaping (DBSubcategory) -> ()) {
//        let accessToken = getCurrentAccessToken()
//        if accessToken.isEmpty {
//            print("No access token available. Initiating re-login.")
//            reloginAndRetry {
//                fetchSubcategoryFromDatabase(categoryId: categoryId, subcategoryId: subcategoryId, completion: completion)
//            }
//            return
//        }
//
//        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(categoryId)/subcategories/\(subcategoryId)") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard error == nil else {
//                print("Error: ", error!)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else { return }
//
//            if httpResponse.statusCode == 401 {
//                refreshAccessToken { success in
//                    if success {
//                        fetchSubcategoryFromDatabase(categoryId: categoryId, subcategoryId: subcategoryId, completion: completion)
//                    } else {
//                        reloginAndRetry {
//                            fetchSubcategoryFromDatabase(categoryId: categoryId, subcategoryId: subcategoryId, completion: completion)
//                        }
//                    }
//                }
//            } else if let data = data {
//                do {
//                    let jsonData = try JSONDecoder().decode(DBSubcategory.self, from: data)
//                    completion(jsonData)
//                } catch {
//                    print("Error: ", error)
//                }
//            }
//        }.resume()
//    }
    
    static func postFoodToDatabase(categoryId: Int, subcategoryId: Int, dbFood: BMFood) {
        let accessToken = getCurrentAccessToken()
        if accessToken.isEmpty {
            print("No access token available. Initiating re-login.")
            reloginAndRetry {
                postFoodToDatabase(categoryId: categoryId, subcategoryId: subcategoryId, dbFood: dbFood)
            }
            return
        }

        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(categoryId)/subcategories/\(subcategoryId)/foods") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(dbFood)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making POST request: \(error.localizedDescription)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        refreshAccessToken { success in
                            if success {
                                postFoodToDatabase(categoryId: categoryId, subcategoryId: subcategoryId, dbFood: dbFood)
                            } else {
                                reloginAndRetry {
                                    postFoodToDatabase(categoryId: categoryId, subcategoryId: subcategoryId, dbFood: dbFood)
                                }
                            }
                        }
                    } else if httpResponse.statusCode == 201 {
                        print("Food item posted successfully")
                    } else {
                        print("HTTP Request failed with status code: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func updateFoodInDatabase(categoryId: Int, subcategoryId: Int, dbFood: BMFood) {
        let accessToken = getCurrentAccessToken()
        if accessToken.isEmpty {
            print("No access token available. Initiating re-login.")
            reloginAndRetry {
                updateFoodInDatabase(categoryId: categoryId, subcategoryId: subcategoryId, dbFood: dbFood)
            }
            return
        }

        guard let url = URL(string: "https://stingray-app-2t6j4.ondigitalocean.app/api/categories/\(categoryId)/subcategories/\(subcategoryId)/foods/\(dbFood.id)") else {
            print("Invalid URL")
            return
        }

        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(dbFood)
            request.httpBody = jsonData
            print("posting")
            print(dbFood)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON String: \(jsonString)")
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making PUT request: \(error.localizedDescription)")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                        refreshAccessToken { success in
                            if success {
                                updateFoodInDatabase(categoryId: categoryId, subcategoryId: subcategoryId, dbFood: dbFood)
                            } else {
                                reloginAndRetry {
                                    updateFoodInDatabase(categoryId: categoryId, subcategoryId: subcategoryId, dbFood: dbFood)
                                }
                            }
                        }
                    } else if httpResponse.statusCode == 200 {
                        print("Food item updated successfully")
                    } else {
                        print("HTTP Request failed with status code: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

}
