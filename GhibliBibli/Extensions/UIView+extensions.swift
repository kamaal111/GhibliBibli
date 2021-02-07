//
//  UIView+extensions.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 29/01/2021.
//

import SwiftUI

extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView

        func makeUIView(context: Context) -> some UIView { view }

        func updateUIView(_ uiView: UIViewType, context: Context) { }
    }

    func toSwiftUIView() -> some View {
        Preview(view: self)
    }
}
