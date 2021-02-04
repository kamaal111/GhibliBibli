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

    private var filmPeople: [GhibliPeople] = [] {
        didSet { filmPeopleDidSet() }
    }

    private let networker = NetworkController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView.filmImageView(image: ghibliFilm?.uiImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var filmTitleLabel: UILabel = {
        let label = UILabel.filmTitleLabel(title: ghibliFilm?.title)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var releaseYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .headline)
        if let releaseDate = ghibliFilm?.releaseDate {
            label.text = "\(releaseDate)"
        }
        return label
    }()

    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel.filmTitleLabel(title: ghibliFilm?.originalTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.frame.size = self.view.frame.size
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .systemBackground
        /// - TODO: Make the scrollview height dynamic, by calculating sub view heights 😭
        scroll.contentSize = self.view.frame.size
        return scroll
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

        let charactersTitle = UILabel.sectionHeader(text: "Characters")
        charactersTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(charactersTitle)

        let firstPerson = filmPeople.first!
        let firstPersonButton = UIButton.filmCharacterButton(containerViewSize: containerView.frame.size, title: firstPerson.name)
        firstPersonButton.tag = 0
        firstPersonButton.translatesAutoresizingMaskIntoConstraints = false
        firstPersonButton.addTarget(self, action: #selector(personButtonAction), for: .touchUpInside)
        self.view.addSubview(firstPersonButton)

        NSLayoutConstraint.activate([
            charactersTitle.topAnchor.constraint(equalTo: filmImageView.bottomAnchor, constant: 16),
            charactersTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            firstPersonButton.topAnchor.constraint(equalTo: charactersTitle.bottomAnchor, constant: 4),
            firstPersonButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            firstPersonButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32)
        ])

        let peopleButtons: [UIButton] = filmPeople[1..<filmPeople.count]
            .enumerated()
            .map { (enumarated: EnumeratedSequence<ArraySlice<GhibliPeople>>.Iterator.Element) -> UIButton in
                let button = UIButton.filmCharacterButton(containerViewSize: containerView.frame.size, title: enumarated.element.name)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.tag = enumarated.offset + 1
                button.addTarget(self, action: #selector(personButtonAction), for: .touchUpInside)
                return button
            }

        for (index, personButton) in peopleButtons.enumerated() {
            containerView.addSubview(personButton)
            let topPadding: CGFloat = 8
            if index == 0 {
                personButton.topAnchor.constraint(equalTo: firstPersonButton.bottomAnchor, constant: topPadding).isActive = true
            } else {
                personButton.topAnchor.constraint(equalTo: peopleButtons[index - 1].bottomAnchor, constant: topPadding).isActive = true
            }
            personButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
            personButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -32).isActive = true
        }
    }

    private func setupView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = ghibliFilm?.title
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(scrollView)

        scrollView.addSubview(containerView)

        containerView.addSubview(filmImageView)
        containerView.addSubview(filmTitleLabel)
        containerView.addSubview(releaseYearLabel)
        containerView.addSubview(originalTitleLabel)

        setupConstraints()
        processGhibliFilm()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),

            filmImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            filmImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            filmImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.widestEdge / 2.5),
            filmImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.narrowestEdge / 2.5),

            filmTitleLabel.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 16),
            filmTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            filmTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

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
