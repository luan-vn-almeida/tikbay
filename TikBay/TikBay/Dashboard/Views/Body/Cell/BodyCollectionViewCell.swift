//
//  BodyCollectionViewCell.swift
//  TikBay
//
//  Created by Luan Almeida on 27/03/23.
//

import UIKit
import AVKit
import AVFoundation

class BodyCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BodyCollectionViewCell"
    
    private var viewModel: BodyCollectionViewModelProtocol = BodyCollectionViewModel()
    
    enum ViewMetrics {
        
        enum Subtitle {
            static let leading: CGFloat = 16
            static let trailing: CGFloat = -16
            static let bottom: CGFloat = -50
        }
        
        enum ReactView {
            static let width: CGFloat = 90
            static let trailing: CGFloat = -30
            static let leading: CGFloat = 30
        }
    }
    
    private var videoPlayer: AVPlayer?
    private var audioPlayer: AVAudioPlayer?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var reactionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.alpha = 0
        return view
    }()

    private lazy var playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return playerLayer
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.dropShadow()
        return label
    }()
    
    private lazy var heartReactionView: ReactionView = {
        let view = ReactionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var fireReactionView: ReactionView = {
        let view = ReactionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(look: Look) {
        viewModel.delegate = self
        viewModel.set(look: look)
        heartReactionView.set(look: look, type: .heart)
        fireReactionView.set(look: look, type: .fire)
    }
    
    func videoObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
        videoPlayer?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            if videoPlayer?.rate ?? 0 > 0 {
                self.hideThumbnail()
            }
        }
    }
    
    private func hideThumbnail() {
        DispatchQueue.main.async {
            if self.reactionView.alpha == 0 {
                UIView.animate(withDuration: 0.5, delay: 0.5) { [weak self] in
                    self?.reactionView.alpha = 1
                    self?.thumbnailImageView.alpha = 0
                }
            }
        }
    }
    
    @objc func didTapSnap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: self)
        saveReactionBy(touchLocation: touchLocation)
    }
    
    private func saveReactionBy(touchLocation: CGPoint) {
        if touchLocation.x < frame.width / 2 {
            viewModel.saveReact(type: .heart)
            createIcon(point: touchLocation, type: .heart)
            heartReactionView.update()
        } else {
            viewModel.saveReact(type: .fire)
            createIcon(point: touchLocation, type: .fire)
            fireReactionView.update()
        }
    }
    
    func createIcon(point: CGPoint, type: ReactionType) {
        guard let icon = type.icon() else {
            return
        }
        let imageView = UIImageView(frame: .init(origin: .zero, size: .init(width: 50, height: 50)))
        imageView.image = icon
        imageView.tintColor = .red
        imageView.alpha = 1
        imageView.center = point
        containerView.addSubview(imageView)
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn) {
            imageView.transform = .init(translationX: 0, y: -90)
            imageView.alpha = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                imageView.removeFromSuperview()
            }
        }
    }
    
    func loadVideo() {
        viewModel.loadVideo()
    }
    
    func stopVideo() {
        playerLayer.player?.pause()
        audioPlayer?.stop()
        reactionView.alpha = 0
        thumbnailImageView.alpha = 1
    }
}

extension BodyCollectionViewCell: ViewConfiguration {
    
    func buildViewHierarchy() {
        addSubview(reactionView)
        addSubview(containerView)
        
        reactionView.addSubview(heartReactionView)
        reactionView.addSubview(fireReactionView)
        
        containerView.addSubview(rightView)
        containerView.addSubview(leftView)
        containerView.layer.insertSublayer(playerLayer, at: 0)
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(subtitleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            reactionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reactionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reactionView.topAnchor.constraint(equalTo: topAnchor),
            reactionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            heartReactionView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                       constant: ViewMetrics.ReactView.leading),
            heartReactionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightView.topAnchor.constraint(equalTo: topAnchor),
            rightView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightView.widthAnchor.constraint(equalToConstant: ViewMetrics.ReactView.width)
        ])
        
        NSLayoutConstraint.activate([
            leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftView.topAnchor.constraint(equalTo: topAnchor),
            leftView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftView.widthAnchor.constraint(equalToConstant: ViewMetrics.ReactView.width)
        ])
        
        NSLayoutConstraint.activate([
            fireReactionView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: ViewMetrics.ReactView.trailing),
            fireReactionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                  constant: ViewMetrics.Subtitle.bottom),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                   constant: ViewMetrics.Subtitle.leading),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                    constant: ViewMetrics.Subtitle.trailing)
        ])
    }
    
    
    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self.containerView)
            UIView.animate(withDuration: 0.5) {
                self.containerView.center = CGPoint(x: self.containerView.center.x + translation.x, y: self.containerView.center.y)
                sender.setTranslation(.zero, in: self.containerView)
            }
        case .ended, .cancelled:
            let originTouch = sender.location(in: self.containerView)
            saveReactionBy(touchLocation: originTouch)
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.7,
                           options: [.curveEaseInOut]) {
                self.containerView.center = self.thumbnailImageView.center
            }
        default: break
        }
    }
    
    func configureViews() {
        playerLayer.frame = bounds
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapSnap(_:)))
        tapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGesture)
        
        let panGestureRecognizer1 = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePanGesture(_:)))
        rightView.addGestureRecognizer(panGestureRecognizer1)
        
        let panGestureRecognizer2 = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePanGesture(_:)))
        leftView.addGestureRecognizer(panGestureRecognizer2)

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        
        isUserInteractionEnabled = true
    }
}

extension BodyCollectionViewCell: BodyCollectionViewModelOutput {
    
    func loadedThumbnaill(image: UIImage) {
        thumbnailImageView.image = image
    }
    
    func loadedBody(description: String) {
        subtitleLabel.text = description
    }
    
    func play() {
        videoPlayer?.play()
        audioPlayer?.play()
    }

    func loadVideoAndAudio(videoURL: URL, audioURL: URL) {
        //Prepare Video
        self.videoPlayer = AVPlayer(url: videoURL)
        playerLayer.player = self.videoPlayer
        
        //Prepare Audio
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: audioURL)
                self.audioPlayer = try AVAudioPlayer(data: data)
                self.audioPlayer?.numberOfLoops = -1
                self.videoObservers()
                self.play()
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
