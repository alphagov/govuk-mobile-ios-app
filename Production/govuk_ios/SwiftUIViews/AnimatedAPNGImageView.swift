import SwiftUI

struct AnimatedAPNGImageView: UIViewRepresentable {
    let imageName: String

    func makeUIView(context: Context) -> some UIView {
        let containerView = UIView()

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png"),
              let data = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return containerView
        }

        let frameCount = CGImageSourceGetCount(source)
        guard frameCount > 1 else {
            return containerView
        }

        var images = [UIImage]()
        var totalDuration: Double = 0.0
        for frames in 0..<frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, frames, nil) else {
                continue
            }
            let frameDuration = source.pngFrameDuration(at: frames)
            totalDuration += frameDuration
            let image = UIImage(cgImage: cgImage)
            images.append(image)
        }

        imageView.image = UIImage.animatedImage(with: images, duration: totalDuration)
        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)])
        containerView.layoutIfNeeded()

        return containerView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
