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
        imageView.layer.cornerRadius = 36
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.backgroundColor = .label
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let pronounsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.isHidden = true
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
        label.font = .systemFont(ofSize: 12, weight: .medium)
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
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var contactStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.isHidden = true
        return stack
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, pronounsLabel, locationStack, bioLabel, contactStack])
        stack.axis = .vertical
        stack.spacing = 10
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
        pronounsLabel.text = nil
        pronounsLabel.isHidden = true
        locationLabel.text = nil
        bioLabel.text = nil
        locationStack.isHidden = false
        bioLabel.isHidden = false
        contactStack.removeAllArrangedSubviews()
        contactStack.isHidden = true
    }

    private func configureLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(contentStack)

        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 72, height: 72))
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }

        contentStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        bioLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        bioLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        locationIconView.setContentHuggingPriority(.required, for: .horizontal)
    }

    func configure(with model: MainMeModel) {
        nameLabel.text = model.name

        if let pronouns = model.gender?.nilIfEmpty {
            pronounsLabel.text = pronouns
            pronounsLabel.isHidden = false
        } else {
            pronounsLabel.text = nil
            pronounsLabel.isHidden = true
        }

        let resolvedLocation = model.location?.nilIfEmpty ?? model.locationDetails?.formattedAddress?.nilIfEmpty
        if let location = resolvedLocation {
            locationLabel.text = location
            locationStack.isHidden = false
        } else {
            locationLabel.text = nil
            locationStack.isHidden = true
        }

        let resolvedBio = model.bio?.nilIfEmpty ?? model.shortBio?.nilIfEmpty
        if let bio = resolvedBio {
            bioLabel.text = bio
            bioLabel.isHidden = false
        } else {
            bioLabel.text = nil
            bioLabel.isHidden = true
        }

        configureContacts(from: model)

        if let url = model.pictures?.sizes?.last?.link ?? model.pictures?.baseLink {
            avatarImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
    }

    private func configureContacts(from model: MainMeModel) {
        contactStack.removeAllArrangedSubviews()

        let items = buildContactItems(from: model)

        guard !items.isEmpty else {
            contactStack.isHidden = true
            return
        }

        contactStack.isHidden = false

        items.forEach { item in
            let row = makeContactRow(iconSystemName: item.iconSystemName, text: item.title)
            contactStack.addArrangedSubview(row)
        }
    }

    private func makeContactRow(iconSystemName: String, text: String) -> UIStackView {
        let imageView = UIImageView(image: UIImage(systemName: iconSystemName))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
        }

        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = text

        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top

        return stack
    }
}

private extension UIStackView {
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

private extension MainMeInfoCell {

    struct ContactItem {
        let iconSystemName: String
        let title: String
        let url: URL?
    }

    func buildContactItems(from model: MainMeModel) -> [ContactItem] {
        var items: [ContactItem] = []

        if let link = model.link {
            items.append(.init(iconSystemName: "link",
                               title: link.absoluteString,
                               url: link))
        }

        if let websites = model.websites {
            for website in websites {
                guard let url = website.link else { continue }

                let scheme = url.scheme?.lowercased()
                let isMail = scheme == "mailto"

                let displayText: String
                if isMail {
                    displayText = url.path.nilIfEmpty ?? url.absoluteString
                } else if let name = website.name?.nilIfEmpty {
                    displayText = name
                } else if let description = website.description?.nilIfEmpty {
                    displayText = description
                } else {
                    displayText = url.absoluteString
                }

                let icon = isMail ? "envelope" : "link"
                items.append(.init(iconSystemName: icon,
                                   title: displayText,
                                   url: url))
            }
        }

        return items
    }
}

private extension String {
    var nilIfEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
