//
//  APITokenResponse.swift
//  bitemap
//
//  Created by Simonas Kytra on 03/12/2023.
//

import Foundation

struct TokenResponse: Codable {
    let access_token: String
    let refresh_token: String
}
