//
//  MainMeService.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import Foundation

protocol MainMeServicing {
    func fetchMe() async throws -> MainMeModel
}

final class MainMeService: MainMeServicing {

    private let session: URLSession
    private let config: APIConfiguration

    init(session: URLSession = .shared, config: APIConfiguration = APIConfig.shared) {
        self.session = session
        self.config = config
    }

    func fetchMe() async throws -> MainMeModel {
        guard let token = config.personalAccessToken, !token.isEmpty else {
            let error = APIError.missingToken
            config.log(error)
            throw error
        }

        guard let requestURL = URL(string: APIConfig.MePath.me, relativeTo: config.baseURL) else {
            let error = APIError.invalidURL
            config.log(error)
            throw error
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            if let http = response as? HTTPURLResponse {
                print("HTTP status:", http.statusCode)
                print("Response body:", String(data: data, encoding: .utf8) ?? "No body")
            }
            let error = APIError.invalidResponse
            config.log(error)
            throw error
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            return try decoder.decode(MainMeModel.self, from: data)
        } catch {
            print("[MainMeService] Decoding error:", error)
            print("[MainMeService] Raw response:", String(data: data, encoding: .utf8) ?? "<invalid utf8>")
            throw error
        }
    }
}

