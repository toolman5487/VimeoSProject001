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
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        imageView.backgroundColor = .tertiarySystemFill
        return imageView
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
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.addSubview(avatarImageView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        avatarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }

    func configure(with model: MainMeModel) {
        if let url = MainMeViewModel.bestAvatarURL(for: model, preferred: .square100) {
            avatarImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
    }
}
