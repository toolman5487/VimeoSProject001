//
//  APIConfig.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import Foundation

protocol APIConfiguration {
    var baseURL: URL { get }
    var personalAccessToken: String? { get }
    func log(_ error: APIError)
}

struct APIConfig: APIConfiguration {
    static let shared = APIConfig()

    let baseURL = URL(string: "https://api.vimeo.com")!

    var personalAccessToken: String? {
        Bundle.main.object(forInfoDictionaryKey: "VimeoPersonalAccessToken") as? String
    }

    func log(_ error: APIError) {
        error.log()
    }

    enum MePath {
        static let me = "/me"
        static let myVideos = "/me/videos"
        static let myAlbums = "/me/albums"
        static let myLikes = "/me/likes"
        static let myFollowers = "/me/followers"
        static let myFollowing = "/me/following"
        static let myTeams = "/me/teams"
        static let myPictures = "/me/pictures"
    }
}

enum APIError: Error {
    case missingToken
    case invalidURL
    case invalidResponse

    func log() {
        let message: String
        switch self {
        case .missingToken:
            message = "APIConfig: Personal Access Token is missing or empty."
        case .invalidURL:
            message = "APIConfig: Failed to generate a valid request URL."
        case .invalidResponse:
            message = "APIConfig: Received an unexpected HTTP response."
        }
        print(message)
    }
}
