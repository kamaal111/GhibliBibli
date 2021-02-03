//
//  FilmDetailsViewController.swift
//  GhibliBibli
//
//  Created by Kamaal M Farah on 30/01/2021.
//

import UIKit
import GhibliNet

class FilmDetailsViewController: UIViewController {

    var ghibliFilm: GhibliFilm?
    var filmPeople: [GhibliPeople] = [] {
        didSet { filmPeopleDidSet() }
    }

    private let networker = NetworkController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.shadowColor = UIColor.accentColor.cgColor
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.shadowRadius = 4
        imageView.clipsToBounds = false
        imageView.image = ghibliFilm?.uiImage
        return imageView
    }()

    private lazy var filmTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = ghibliFilm?.title
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()

    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        if let releaseDate = ghibliFilm?.releaseDate {
            label.text = "\(releaseDate)"
        }
        return label
    }()

    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = ghibliFilm?.originalTitle
        label.font = .preferredFont(forTextStyle: .headline)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()

    private func processGhibliFilm() {
        if let ghibliFilm = ghibliFilm {
            switch networker.ghibli.getFilmPeople(of: ghibliFilm) {
            case .failure(let failure):
                print(failure)
            case .success(let success):
                filmPeople = success
            }
        }
    }

    @objc
    func personButtonAction(_ sender: UIButton) {
        let characterDetailViewController = CharacterDetailViewController()
        characterDetailViewController.character = filmPeople[sender.tag]
        self.navigationController?.pushViewController(characterDetailViewController, animated: true)
    }

    private func filmPeopleDidSet() {
        guard !filmPeople.isEmpty else { return }
        let charactersTitle = UILabel()
        charactersTitle.font = .preferredFont(forTextStyle: .headline)
        charactersTitle.textColor = .secondaryLabel
        charactersTitle.text = "Characters"
        charactersTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(charactersTitle)

        let firstPerson = filmPeople.first!
        let firstPersonButton = UIButton(type: .system)
        firstPersonButton.tag = 0
        firstPersonButton.translatesAutoresizingMaskIntoConstraints = false
        firstPersonButton.setTitle(firstPerson.name, for: .normal)
        firstPersonButton.setTitleColor(.label, for: .normal)
        firstPersonButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
        firstPersonButton.addTarget(self, action: #selector(personButtonAction), for: .touchUpInside)
        firstPersonButton.contentHorizontalAlignment = .leading
        let chevronRightImage = UIImage(systemName: "chevron.right")
        firstPersonButton.setImage(chevronRightImage, for: .normal)
        let chevronRightImageWidth = chevronRightImage?.size.width ?? 0
        firstPersonButton.titleEdgeInsets.left = -chevronRightImageWidth
        firstPersonButton.imageEdgeInsets.left = self.view.frame.width - chevronRightImageWidth - 32
        firstPersonButton.contentEdgeInsets.right = -self.view.frame.width
        self.view.addSubview(firstPersonButton)

        NSLayoutConstraint.activate([
            charactersTitle.topAnchor.constraint(equalTo: filmImageView.bottomAnchor, constant: 16),
            charactersTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            firstPersonButton.topAnchor.constraint(equalTo: charactersTitle.bottomAnchor, constant: 4),
            firstPersonButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            firstPersonButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])

        let peopleButtons: [UIButton] = filmPeople[1..<filmPeople.count]
            .enumerated()
            .map { (enumarated: EnumeratedSequence<ArraySlice<GhibliPeople>>.Iterator.Element) -> UIButton in
                let button = UIButton(type: .system)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.tag = enumarated.offset + 1
                button.setTitle(enumarated.element.name, for: .normal)
                button.setTitleColor(.label, for: .normal)
                button.titleLabel?.font = .preferredFont(forTextStyle: .body)
                button.addTarget(self, action: #selector(personButtonAction), for: .touchUpInside)
                button.contentHorizontalAlignment = .leading
                let chevronRightImage = UIImage(systemName: "chevron.right")
                button.setImage(chevronRightImage, for: .normal)
                let chevronRightImageWidth = chevronRightImage?.size.width ?? 0
                button.titleEdgeInsets.left = -chevronRightImageWidth
                button.imageEdgeInsets.left = self.view.frame.width - chevronRightImageWidth - 32
                button.contentEdgeInsets.right = -self.view.frame.width
                return button
            }

        for (index, personButton) in peopleButtons.enumerated() {
            self.view.addSubview(personButton)
            let topPadding: CGFloat = 8
            if index == 0 {
                personButton.topAnchor.constraint(equalTo: firstPersonButton.bottomAnchor, constant: topPadding).isActive = true
            } else {
                personButton.topAnchor.constraint(equalTo: peopleButtons[index - 1].bottomAnchor, constant: topPadding).isActive = true
            }
            personButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            personButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -32).isActive = true
        }
    }

    private func setupView() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = ghibliFilm?.title

        self.view.addSubview(filmImageView)
        self.view.addSubview(filmTitleLabel)
        self.view.addSubview(releaseYearLabel)
        self.view.addSubview(originalTitleLabel)

        setupConstraints()
        processGhibliFilm()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filmImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filmImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.widestEdge / 2.5),
            filmImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.narrowestEdge / 2.5),
            filmTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            filmTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filmTitleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            releaseYearLabel.topAnchor.constraint(equalTo: filmTitleLabel.bottomAnchor, constant: 8),
            releaseYearLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            originalTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            originalTitleLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 8)
        ])
    }

}

#if DEBUG
import SwiftUI
struct FilmDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let filmDetailViewController = FilmDetailsViewController()
        let ghibliFilm = try? NetworkController.shared.ghibli.getFilms().get().first { !$0.people.isEmpty }
        filmDetailViewController.ghibliFilm = ghibliFilm
        return UINavigationController(rootViewController: filmDetailViewController)
                .toSwiftUIView()
                .edgesIgnoringSafeArea(.all)
                .colorScheme(.dark)
    }
}
#endif
