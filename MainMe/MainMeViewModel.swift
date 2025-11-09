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

    func load() async {
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

    static func makeInfoContent(from model: MainMeModel) -> (name: String, location: String?, bio: String?, avatarURL: URL?) {
        let location = model.location ?? model.locationDetails?.formattedAddress
        let bio = model.bio ?? model.shortBio
        let avatarURL = model.pictures?.sizes?.last?.link ?? model.pictures?.baseLink
        return (name: model.name,
                location: location?.nilIfEmpty,
                bio: bio?.nilIfEmpty,
                avatarURL: avatarURL)
    }
}

private extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

