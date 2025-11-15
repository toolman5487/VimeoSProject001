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

// MARK: - AvartaCell
final class MainMeAvartaCell: UITableViewCell {
    
    static let reuseIdentifier = "MainMeAvartaCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.vimeoBlue.cgColor
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let placeholderImage = UIImage(systemName: "person.crop.circle.fill")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.sd_cancelCurrentImageLoad()
        avatarImageView.image = placeholderImage
        nameLabel.text = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        avatarImageView.tintColor = .vimeoWhite
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configure(with model: MainMeModel) {
        nameLabel.text = model.name
        
        if let url = MainMeViewModel.bestAvatarURL(for: model, preferred: .square300) {
            avatarImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
    }
}

// MARK: - InfoCell
final class MainMeInfoCell: UITableViewCell {
    
    static let reuseIdentifier = "MainMeInfoCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .vimeoWhite
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(8)
        }
    }
    
    func configure(with model: MainMeModel) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Gender
        if let formattedGender = MainMeViewModel.formatGender(model.gender) {
            let label = makeInfoRow(iconSystemName: "person.fill", text: formattedGender)
            stackView.addArrangedSubview(label)
        }
        
        // Location
        if let location = model.location?.nilIfEmpty ?? model.locationDetails?.formattedAddress?.nilIfEmpty {
            let label = makeInfoRow(iconSystemName: "mappin.and.ellipse", text: location)
            stackView.addArrangedSubview(label)
        }
        
        // Websites
        if let websites = model.websites {
            for website in websites {
                guard let url = website.link else { continue }
                
                let displayText: String
                if let name = website.name?.nilIfEmpty {
                    displayText = name
                } else if let description = website.description?.nilIfEmpty {
                    displayText = description
                } else {
                    displayText = url.absoluteString
                }
                
                let scheme = url.scheme?.lowercased()
                let isMail = scheme == "mailto"
                let icon = isMail ? "envelope.fill" : "link"
                
                let label = makeInfoRow(iconSystemName: icon, text: displayText)
                stackView.addArrangedSubview(label)
            }
        }
        
        // Bio
        if let bio = model.bio?.nilIfEmpty ?? model.shortBio?.nilIfEmpty {
            let label = makeInfoRow(iconSystemName: "text.alignleft", text: bio)
            stackView.addArrangedSubview(label)
        }
    }
    
    private func makeInfoRow(iconSystemName: String, text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        
        guard let iconImage = UIImage(systemName: iconSystemName)?.withTintColor(.vimeoBlack, renderingMode: .alwaysOriginal) else {
            label.text = text
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .vimeoBlack
            return label
        }
        
        let attachment = NSTextAttachment()
        attachment.image = iconImage
        let iconSize: CGFloat = 16
        attachment.bounds = CGRect(x: 0, y: -2, width: iconSize, height: iconSize)
        
        let iconString = NSAttributedString(attachment: attachment)
        let spacingString = NSAttributedString(string: "  ", attributes: [.font: UIFont.systemFont(ofSize: 16)])
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.vimeoBlack
        ]
        let textString = NSAttributedString(string: text, attributes: textAttributes)
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(iconString)
        attributedText.append(spacingString)
        attributedText.append(textString)
        
        label.attributedText = attributedText
        return label
    }
}
