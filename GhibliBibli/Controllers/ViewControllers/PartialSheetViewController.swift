//
//  PartialSheetViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 08/02/2021.
//

import UIKit

class PartialSheetViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var sheetHeight: CGFloat?

    private var isPresenting = false

    convenience init(sheetHeight: CGFloat) {
        self.init()

        self.sheetHeight = sheetHeight
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(backdropView)
        self.view.addSubview(sheetView)

        NSLayoutConstraint.activate([
            sheetView.heightAnchor.constraint(equalToConstant: sheetHeight ?? defaultSheetHeight),
            sheetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sheetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }

    private lazy var defaultSheetHeight: CGFloat = {
        self.view.frame.height / 3
    }()

    private lazy var backdropView: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        return view
    }()

    private lazy var sheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc
    private func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension PartialSheetViewController: UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.5 }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        isPresenting.toggle()

        let sheetHeight = self.sheetHeight ?? self.defaultSheetHeight
        if isPresenting == true {
            transitionContext.containerView.addSubview(toViewController.view)

            sheetView.frame.origin.y += sheetHeight
            backdropView.alpha = 0

            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.sheetView.frame.origin.y -= sheetHeight
                self.backdropView.alpha = 1
            }) { (fineshed: Bool) in
                transitionContext.completeTransition(true)
            }
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                guard let self = self else { return }
                self.sheetView.frame.origin.y += sheetHeight
                self.backdropView.alpha = 0
            }) { (finished: Bool) in
                transitionContext.completeTransition(true)
            }
        }
    }
}
