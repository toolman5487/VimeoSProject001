//
//  MainMeModel.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import Foundation

struct MainMeModel: Decodable {
    struct Capabilities: Decodable {
        let hasLiveSubscription: Bool?
    }

    struct PictureVariant: Decodable {
        let width: Int
        let height: Int
        let link: URL
    }

    struct Pictures: Decodable {
        let uri: String?
        let active: Bool?
        let type: String?
        let baseLink: URL?
        let sizes: [PictureVariant]?
        let resourceKey: String?
        let defaultPicture: Bool?

        private enum CodingKeys: String, CodingKey {
            case uri, active, type
            case baseLink = "base_link"
            case sizes
            case resourceKey = "resource_key"
            case defaultPicture = "default_picture"
        }
    }

    struct Website: Decodable {
        let name: String?
        let description: String?
        let link: URL?
    }

    struct Connections: Decodable {
        struct Connection: Decodable {
            let uri: String?
            let options: [String]?
            let total: Int?
        }
        let albums: Connection?
        let videos: Connection?
        let likes: Connection?
        let followers: Connection?
        let following: Connection?
        let channels: Connection?
        let groups: Connection?
        let teams: Connection?
        let pictures: Connection?
        let feed: Connection?
        let shared: Connection?
        let foldersRoot: Connection?

        private enum CodingKeys: String, CodingKey {
            case albums, videos, likes, followers, following, channels, groups, teams, pictures, feed, shared
            case foldersRoot = "folders_root"
        }
    }

    struct Metadata: Decodable {
        let connections: Connections?
    }

    struct LocationDetails: Decodable {
        let formattedAddress: String?
        let latitude: Double?
        let longitude: Double?
        let city: String?
        let state: String?
        let country: String?

        private enum CodingKeys: String, CodingKey {
            case formattedAddress = "formatted_address"
            case latitude, longitude, city, state, country
        }
    }

    let uri: String
    let name: String
    let link: URL?
    let capabilities: Capabilities?
    let location: String?
    let gender: String?
    let bio: String?
    let shortBio: String?
    let createdTime: String?
    let pictures: Pictures?
    let websites: [Website]?
    let metadata: Metadata?
    let locationDetails: LocationDetails?
    let skills: [String]?
    let availableForHire: Bool?
    let canWorkRemotely: Bool?
    let resourceKey: String?
    let account: String?

    private enum CodingKeys: String, CodingKey {
        case uri, name, link, capabilities, location, gender, bio, websites, metadata, skills, account
        case shortBio = "short_bio"
        case createdTime = "created_time"
        case pictures
        case locationDetails = "location_details"
        case availableForHire = "available_for_hire"
        case canWorkRemotely = "can_work_remotely"
        case resourceKey = "resource_key"
    }
}
