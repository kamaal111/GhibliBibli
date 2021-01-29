//
//  HeaderView.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 29/01/2021.
//

import UIKit

class HeaderView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            textLabel.heightAnchor.constraint(equalToConstant: 30),
            textLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Ghibli Bibli"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

}

#if DEBUG
import SwiftUI
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 400)))
            .toSwiftUIView()
            .previewLayout(.sizeThatFits)
    }
}
#endif
