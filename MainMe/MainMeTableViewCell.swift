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
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 4
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
            make.top.bottom.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
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

// MARK: - InfoRowView
final class InfoRowView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    var showSeparator: Bool = true {
        didSet {
            separatorView.isHidden = !showSeparator
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemGroupedBackground
        
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(separatorView)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func configure(iconSystemName: String, title: String, showSeparator: Bool = true) {
        iconImageView.image = UIImage(systemName: iconSystemName)
        titleLabel.text = title
        self.showSeparator = showSeparator
    }
}

// MARK: - InfoCell
final class MainMeInfoCell: UITableViewCell {
    
    static let reuseIdentifier = "MainMeInfoCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private var infoRowViews: [InfoRowView] = []
    
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
        infoRowViews.removeAll()
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
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with model: MainMeModel) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        infoRowViews.removeAll()
        
        var rows: [(icon: String, title: String)] = []
        
        // Gender
        if let formattedGender = MainMeViewModel.formatGender(model.gender) {
            rows.append((icon: "person.fill", title: formattedGender))
        }
        
        // Location
        if let location = model.location?.nilIfEmpty ?? model.locationDetails?.formattedAddress?.nilIfEmpty {
            rows.append((icon: "mappin.and.ellipse", title: location))
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
                
                rows.append((icon: icon, title: displayText))
            }
        }
        
        // Bio
        if let bio = model.bio?.nilIfEmpty ?? model.shortBio?.nilIfEmpty {
            rows.append((icon: "text.alignleft", title: bio))
        }
        
        // 創建並添加 InfoRowView
        for (index, row) in rows.enumerated() {
            let rowView = InfoRowView()
            let isLast = index == rows.count - 1
            rowView.configure(iconSystemName: row.icon, title: row.title, showSeparator: !isLast)
            stackView.addArrangedSubview(rowView)
            infoRowViews.append(rowView)
        }
    }
}
