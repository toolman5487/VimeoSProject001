//
//  MainMeTableViewCell.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/9.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

final class MainMeInfoCell: UITableViewCell {

    struct Content {
        let name: String
        let location: String?
        let bio: String?
        let avatarURL: URL?

        init(name: String, location: String? = nil, bio: String? = nil, avatarURL: URL? = nil) {
            self.name = name
            self.location = location
            self.bio = bio
            self.avatarURL = avatarURL
        }

        init(model: MainMeModel) {
            self.name = model.name
            self.location = model.location ?? model.locationDetails?.formattedAddress
            self.bio = model.bio ?? model.shortBio
            if let url = model.pictures?.sizes?.last?.link ?? model.pictures?.baseLink {
                self.avatarURL = url
            } else {
                self.avatarURL = nil
            }
        }
    }

    static let reuseIdentifier = "MainMeInfoCell"

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .tertiarySystemFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let locationIconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    private lazy var locationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationIconView, locationLabel])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, locationStack, bioLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private let placeholderImage = UIImage(systemName: "person.crop.circle.fill")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
        avatarImageView.image = placeholderImage
        nameLabel.text = nil
        locationLabel.text = nil
        bioLabel.text = nil
        locationStack.isHidden = false
        bioLabel.isHidden = false
    }

    private func configureLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(textStack)

        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }

        textStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }

        bioLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        bioLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        locationIconView.setContentHuggingPriority(.required, for: .horizontal)
    }

    func configure(with content: Content) {
        nameLabel.text = content.name

        let trimmedLocation = content.location?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let location = trimmedLocation, !location.isEmpty {
            locationLabel.text = location
            locationStack.isHidden = false
        } else {
            locationLabel.text = nil
            locationStack.isHidden = true
        }

        let trimmedBio = content.bio?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let bio = trimmedBio, !bio.isEmpty {
            bioLabel.text = bio
            bioLabel.isHidden = false
        } else {
            bioLabel.text = nil
            bioLabel.isHidden = true
        }

        if let url = content.avatarURL {
            avatarImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
    }
}
