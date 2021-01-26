//
//  UIViewController+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 25/01/2021.
//

import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    }

    func toSwiftUIView() -> some View {
        Preview(viewController: self)
    }
}
