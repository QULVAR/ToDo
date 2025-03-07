import UIKit

extension ViewController {

    func LookingForNetViewDidLoad() {
        LookingForNetView.alpha = 0
        LookingForNetView.frame.size = CGSize(width: MainView.frame.width, height: MainView.frame.height)
        LookingForNetView.isHidden = false

        addCircularLoader()

        UIView.animate(withDuration: 0.5) {
            self.LookingForNetView.alpha = 1
        } completion: { _ in
            self.startCheckingNetwork()
        }
    }

    func hideLoader() {
        hideLoaderAfterCurrentCycle {
            UIView.animate(withDuration: 1, animations: {
                self.LookingForNetView.frame.origin.y = -self.LookingForNetView.frame.height
            }, completion: { _ in
                self.LookingForNetView.isHidden = true
                _ = self.dataBase.dataBaseViewDidLoad()
                self.registerPageViewDidLoad()
                self.authPageViewDidLoad()
            })
        }
    }

    func hideLoaderAfterCurrentCycle(completion: @escaping () -> Void) {
        guard let loader = loaderLayer else {
            completion()
            return
        }

        let currentStart = loader.presentation()?.strokeStart ?? 0
        let currentEnd = loader.presentation()?.strokeEnd ?? 0
        let segmentLength: CGFloat = 0.5
        let remainingProgress = 1 - (currentEnd - currentStart)
        let fullCycleDuration: Double = 2.0
        let remainingTime = fullCycleDuration * Double(remainingProgress / segmentLength)

        DispatchQueue.main.asyncAfter(deadline: .now() + remainingTime) { [weak self] in
            guard let self = self else { return }

            UIView.animate(withDuration: 0.3, animations: {
                loader.opacity = 0
            }) { _ in
                loader.removeAllAnimations()
                loader.removeFromSuperlayer()
                self.loaderLayer = nil

                completion()
            }
        }
    }

    func startCheckingNetwork() {
        connectionCheckTimer?.invalidate()

        connectionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if dataBase.checkConnectionNetwork() {
                self.connectionCheckTimer?.invalidate()
                self.hideLoader()
            }
        }
    }

    func addCircularLoader() {
        let diameter: CGFloat = 50
        let loader = CAShapeLayer()

        let yOffset = LookingForNetLabel.frame.maxY + 20
        let center = CGPoint(x: view.bounds.midX, y: (view.bounds.height + yOffset) / 2)

        let startAngle = CGFloat.pi / 2
        let endAngle = startAngle + 2 * .pi

        let circularPath = UIBezierPath(arcCenter: center,
                                         radius: diameter / 2,
                                         startAngle: startAngle,
                                         endAngle: endAngle,
                                         clockwise: true)

        loader.path = circularPath.cgPath
        loader.strokeColor = UIColor.systemBlue.cgColor
        loader.lineWidth = 4
        loader.fillColor = UIColor.clear.cgColor
        loader.lineCap = .round

        loader.opacity = 0 // сначала невидим

        view.layer.addSublayer(loader)
        self.loaderLayer = loader

        UIView.animate(withDuration: 0.5) {
            loader.opacity = 1
        }

        startDynamicLoadingAnimation()
    }

    func startDynamicLoadingAnimation() {
        guard let loader = loaderLayer else { return }

        let segmentLength: CGFloat = 0.5

        let runAnimation = CABasicAnimation(keyPath: "strokeEnd")
        runAnimation.fromValue = 0
        runAnimation.toValue = 1
        runAnimation.duration = 2.0
        runAnimation.repeatCount = .infinity
        runAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let chaseAnimation = CABasicAnimation(keyPath: "strokeStart")
        chaseAnimation.fromValue = -segmentLength
        chaseAnimation.toValue = 1
        chaseAnimation.duration = 2.0
        chaseAnimation.repeatCount = .infinity
        chaseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        loader.strokeStart = 0
        loader.strokeEnd = segmentLength

        loader.add(runAnimation, forKey: "run")
        loader.add(chaseAnimation, forKey: "chase")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func appDidBecomeActive() {
        restartLoaderAnimationIfNeeded()
    }

    @objc func appWillResignActive() {
        saveLoaderState()
    }

    func restartLoaderAnimationIfNeeded() {
        guard let loader = loaderLayer else { return }
        loader.removeAllAnimations()
        startDynamicLoadingAnimation()
    }

    func saveLoaderState() {
        savedStrokeStart = loaderLayer?.presentation()?.strokeStart ?? 0
        savedStrokeEnd = loaderLayer?.presentation()?.strokeEnd ?? 0
    }

}
