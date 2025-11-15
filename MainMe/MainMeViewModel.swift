//
//  MainMeViewModel.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/8.
//

import Foundation
import Combine

@MainActor
final class MainMeViewModel: ObservableObject {
    
    @Published private(set) var me: MainMeModel?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let service: MainMeServicing

    init(service: MainMeServicing) {
        self.service = service
    }

    convenience init() {
        self.init(service: MainMeService())
    }

// MARK: - fetchMeData
    func fetchMeData() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        do {
            let result = try await service.fetchMe()
            me = result
        } catch {
            self.error = error
        }

        isLoading = false
    }

// MARK: - bestAvatarURL
    enum AvatarResolution: Int, CaseIterable {
        case square30 = 30
        case square72 = 72
        case square75 = 75
        case square100 = 100
        case square144 = 144
        case square216 = 216
        case square288 = 288
        case square300 = 300
        case square360 = 360

        var dimension: Int { rawValue }
    }

    static func bestAvatarURL(for model: MainMeModel, preferred resolution: AvatarResolution = .square30) -> URL? {
        guard let pictures = model.pictures else {
            return nil
        }

        if let match = pictures.sizes?.first(where: { $0.width == resolution.dimension && $0.height == resolution.dimension }) {
            return match.link
        }

        if let closest = pictures.sizes?
            .sorted(by: { lhs, rhs in
                let lhsDiff = abs(lhs.width - resolution.dimension) + abs(lhs.height - resolution.dimension)
                let rhsDiff = abs(rhs.width - resolution.dimension) + abs(rhs.height - resolution.dimension)
                return lhsDiff < rhsDiff
            })
            .first {
            return closest.link
        }

        return pictures.baseLink
    }

// MARK: - formatGender
    static func formatGender(_ gender: String?) -> String? {
        guard let gender = gender?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines),
              !gender.isEmpty else {
            return nil
        }
        
        switch gender {
        case "m", "male":
            return "Male"
        case "f", "female":
            return "Female"
        default:
            return gender.capitalized
        }
    }

}

