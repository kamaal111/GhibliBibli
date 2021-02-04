//
//  UIViewController+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        self.addChild(child)
        self.view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

#if DEBUG
import SwiftUI
extension UIViewController {
    func toSwiftUIView() -> some View {
        Preview(viewController: self)
    }

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    }
}
#endif
