import SnapKit
import UIKit
import RxSwift

final class LoginView: UIView {
    // MARK: - Properties
    var bag = DisposeBag()

    private var logoImageView = UIImageView(image: UIImage(named: "logoZeplinClient"))
    private lazy var logoContainer: UIView = {
        let view = UIView()
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { $0.centerX.top.bottom.equalTo(view) }
        return view
    }()
    
    private(set) var loginButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("LOGIN".localized(), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.semiBold(16)
        view.cornerRadius = 24
      view.backgroundColor = Colors.loginButtonBlue.color
        view.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        return view
    }()
    
    private lazy var verticalStack: UIStackView = .create(arrangedSubViews: [logoContainer, loginButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 96)
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [verticalStack].forEach(addSubview(_:))
        
        verticalStack.snp.makeConstraints { $0.center.equalToSuperview() }
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
