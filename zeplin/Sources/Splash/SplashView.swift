import SnapKit
import UIKit

final class SplashView: UIView {
    // MARK: - Properties
    private(set) lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splashIcon")
        return imageView
    }()

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [logoImageView].forEach(addSubview(_:))
        
        backgroundColor = UIColor(hex: 0x1d1d1d)

        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
