//
//  ReactionView.swift
//  TikBay
//
//  Created by Luan Almeida on 28/03/23.
//

import UIKit

class ReactionView: UIView {
    
    enum ViewMetrics {
        
        static let height: CGFloat = 120
        static let width: CGFloat = 100
        
        enum Icon {
            static let size: CGFloat = 80
        }
        
        enum Label {
            static let height: CGFloat = 30
        }
    }
    
    private var viewModel: ReactionViewModelProtocol = ReactionViewModel()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .red
        return imageView
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .red
        label.numberOfLines = 1
        label.textAlignment = .center
        label.dropShadow()
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        buildLayout()
    }
    
    func set(look: Look, type: ReactionType) {
        viewModel.look = look
        viewModel.type = type
        update()
    }
    
    func update() {
        iconImageView.image = viewModel.type.icon()
        quantityLabel.text = viewModel.loadReactions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReactionView: ViewConfiguration {
    
    func buildViewHierarchy() {
        addSubview(iconImageView)
        addSubview(quantityLabel)
    }
    
    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: ViewMetrics.height),
            widthAnchor.constraint(equalToConstant: ViewMetrics.width)
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: ViewMetrics.Icon.size),
            iconImageView.widthAnchor.constraint(equalToConstant: ViewMetrics.Icon.size)
        ])
        
        NSLayoutConstraint.activate([
            quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityLabel.heightAnchor.constraint(equalToConstant: ViewMetrics.Label.height),
            quantityLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor)
        ])
    }
}
