//
//  String+Extension.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/15.
//

import Foundation

extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
