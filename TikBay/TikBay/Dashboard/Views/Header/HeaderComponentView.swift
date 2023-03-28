//
//  HeaderComponentView.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit

class HeaderComponentView: UIView {
    
    enum ViewMetrics {
        
        static let height: CGFloat = 80
        
        enum Profile {
            static let leading: CGFloat = 16
            static let size: CGFloat = 35
            static let radius: CGFloat = 17.5
        }
        
        enum Title {
            static let leading: CGFloat = 14
        }
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = ""
        return label
    }()
    
    private var viewModel: HeaderComponentViewModelProtocol
    
    init(viewModel: HeaderComponentViewModelProtocol = HeaderComponentViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(look: Look?) async {
        guard let look = look else {
            return
        }
        let image = try? await viewModel.downloadProfile(look: look)
        profileImageView.image = image
        titleLabel.text = look.username
    }
}

extension HeaderComponentView: ViewConfiguration {
    
    func buildViewHierarchy() {
        addSubview(profileImageView)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: ViewMetrics.height)
        ])

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewMetrics.Profile.leading),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: ViewMetrics.Profile.size),
            profileImageView.widthAnchor.constraint(equalToConstant: ViewMetrics.Profile.size)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                constant: ViewMetrics.Title.leading),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = ViewMetrics.Profile.radius
        profileImageView.clipsToBounds = true
    }
}
