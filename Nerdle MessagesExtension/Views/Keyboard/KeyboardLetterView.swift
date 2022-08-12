//
//  KeyboardLetterView.swift
//  Nerdle MessagesExtension
//
//  Created by Andrew Carvajal on 7/25/22.
//

import UIKit

protocol LetterDelegate {
    func didTapLetter(_ letter: String)
    func didTapBackspace()
    func didTapEnter()
}

class KeyboardLetterView: UIView {
    
    // MARK: - Properties
    var letterDelegate: LetterDelegate!
    var letterLabel = UILabel()
    var letterConstraints: [NSLayoutConstraint] = []
    var letterState: LetterState = .blank
    var button = UIButton()
    
    // MARK: - Initializers
    init(_ letter: String, frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(letter)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Methods
    func updateColors(for state: LetterState) {
        updateTextColor(for: state)
        updateBackgroundColor(for: state)
    }
    
    
    // MARK: - Private Methods
    private func setupSubviews(_ letter: String) {
        backgroundColor = .nerdleKeyboardLightModeGray
        layer.cornerRadius = 4
        
        letterLabel = UILabel(frame: .zero)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.text = letter
        letterLabel.font = .systemFont(ofSize: letter == "⌫" ? 20 : letter == "ENTER" ? 11 : 10, weight: .bold)
        letterLabel.textAlignment = .center
        letterLabel.textColor = .black
        addSubview(letterLabel)
        
        button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        button.setTitle(letter, for: .normal)
        button.setTitleColor(.clear, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: letter == "⌫" ? 20 : letter == "ENTER" ? 11 : 10, weight: .bold)
        button.titleLabel?.textAlignment = .center
        addSubview(button)
        
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.deactivate(letterConstraints)
        letterConstraints = [
            letterLabel.topAnchor.constraint(equalTo: topAnchor),
            letterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            letterLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            letterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(letterConstraints)
    }
    
    private func updateBackgroundColor(for state: LetterState) {
        switch state {
        case .blank:
            backgroundColor = .nerdleKeyboardLightModeGray
            letterState = .blank
        case .gray:
            backgroundColor = .nerdleLetterLightModeGray
            letterState = .gray
        case .yellow:
            backgroundColor = .nerdleYellow
            letterState = .yellow
        case .green:
            backgroundColor = .nerdleGreen
            letterState = .green
        }
    }
    
    private func updateTextColor(for state: LetterState) {
        if state == .blank {
            letterLabel.textColor = .black
        } else {
            letterLabel.textColor = .white
        }
    }
    
    @objc
    private func didTapButton(sender: UIButton) {
        if let letter = sender.currentTitle {
            if letter == "ENTER" {
                letterDelegate.didTapEnter()
            } else if letter == "⌫" {
                letterDelegate.didTapBackspace()
            } else {
                letterDelegate.didTapLetter(letter)
            }
        }
    }
}
