//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Dinar Mukhlisov on 10.09.2026.
//

import UIKit

final class CatalogCell: UITableViewCell {
    
    static let reuseIdentifier = "CatalogCell"
    
    private let imageHeight: CGFloat = 140
    private let imageWidth: CGFloat = 343
    private let shimmerLayer = CAGradientLayer()
    private var isPlaceholder = false
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .bodyBold
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayoutAndConstraints()
        setupShimmerLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()

        shimmerLayer.frame = coverImageView.bounds
        
        if isPlaceholder,
           shimmerLayer.animation(forKey: "shimmer") == nil {
            startShimmer()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        isPlaceholder = false
        stopShimmer()
        coverImageView.kf.cancelDownloadTask()
        coverImageView.image = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    func configure(with model: CatalogCellModel) {
        isPlaceholder = false
        stopShimmer()
        coverImageView.backgroundColor = .clear
        titleLabel.text = model.title
        coverImageView.kf.setImage(with: model.coverURL)
    }
    
    func configureAsPlaceholder() {
        isPlaceholder = true
        
        coverImageView.kf.cancelDownloadTask()
        coverImageView.image = nil
        
        titleLabel.text = ""
        coverImageView.backgroundColor = UIColor(resource: .ypLightGray)
        
        setNeedsLayout()
    }
    
    private func setupLayoutAndConstraints() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coverImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: imageHeight / imageWidth),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -13),
        ])
    }
    
    private func setupShimmerLayer() {
        shimmerLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.35).cgColor,
            UIColor.clear.cgColor
        ]
        
        shimmerLayer.locations = [0.0, 0.5, 1.0]
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        coverImageView.layer.addSublayer(shimmerLayer)
    }
    
    private func startShimmer() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity

        shimmerLayer.add(animation, forKey: "shimmer")
    }
    
    private func stopShimmer() {
        shimmerLayer.removeAnimation(forKey: "shimmer")
    }
}
