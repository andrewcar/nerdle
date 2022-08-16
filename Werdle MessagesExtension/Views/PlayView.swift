//
//  PlayView.swift
//  Werdle MessagesExtension
//
//  Created by Andrew Carvajal on 8/9/22.
//

import UIKit

protocol PlayDelegate {
    func didTapSendButton()
}

class PlayView: UIView {
    
    // MARK: - Properties
    private var appState: AppState = .grid
    var playDelegate: PlayDelegate!
    
    private var logoView = LogoView()
    private var logoPortraitConstraints: [NSLayoutConstraint] = []
    private var logoLandscapeConstraints: [NSLayoutConstraint] = []

    private var notInWordListView = NotInWordListView()
    private var notInWordListPortraitConstraints: [NSLayoutConstraint] = []
    private var notInWordListLandscapeConstraints: [NSLayoutConstraint] = []
    
    var gridView = GridView()
    private var gridViewPortraitConstraints: [NSLayoutConstraint] = []
    private var gridViewLandscapeConstraints: [NSLayoutConstraint] = []
        
    private var successView = SuccessView()
    private var successPortraitConstraints: [NSLayoutConstraint] = []
    private var successLandscapeConstraints: [NSLayoutConstraint] = []
    
    var keyboardView = KeyboardView()
    private var keyboardPortraitConstraints: [NSLayoutConstraint] = []
    private var keyboardLandscapeConstraints: [NSLayoutConstraint] = []
    
    private var sendButton = UIButton()
    private var sendButtonPortraitConstraints: [NSLayoutConstraint] = []
    private var sendButtonLandscapeConstraints: [NSLayoutConstraint] = []
    var sendButtonShowing = false
    
    private var newGameButton = UIButton()
    private var newGameButtonPortraitConstraints: [NSLayoutConstraint] = []
    private var newGameButtonLandscapeConstraints: [NSLayoutConstraint] = []
    
    private var statsButton = UIButton()
    private var statsButtonPortraitConstraints: [NSLayoutConstraint] = []
    private var statsButtonLandscapeConstraints: [NSLayoutConstraint] = []
    
    private var gridButton = UIButton()
    private var gridButtonPortraitConstraints: [NSLayoutConstraint] = []
    private var gridButtonLandscapeConstraints: [NSLayoutConstraint] = []
    
    private var statsView = StatsView()
    private var statsViewPortraitConstraints: [NSLayoutConstraint] = []
    private var statsViewLandscapeConstraints: [NSLayoutConstraint] = []
    
    private var debugView = DebugView()
    private var debugViewPortraitConstraints: [NSLayoutConstraint] = []
    private var debugViewLandscapeConstraints: [NSLayoutConstraint] = []

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UPDATE CONSTRAINTS
    override func updateConstraints() {
        super.updateConstraints()
        
        if GameModel.shared.isLandscape {
            activateLogoLandscapeConstraints()
            activateGridViewLandscapeConstraints()
            gridView.activateLetterLandscapeConstraints()
            gridView.updateGridLetterColors()
            activateNotInWordListLandscapeConstraints()
            activateKeyboardLandscapeConstraints()
            keyboardView.updateSubviews(isLandscape: true)
            activateSendButtonLandscapeConstraints()
            updateStatsButton(isLandscape: true)
            activateStatsViewLandscapeConstraints()
            statsView.updateConstraints()
            updateNewGameButton(isLandscape: true)
            activateSuccessLandscapeConstraints()
            activateDebugLandscapeConstraints()
            updateGridButton(isLandscape: true)
        } else {
            activateLogoPortraitConstraints()
            activateGridViewPortraitConstraints()
            gridView.activateLetterPortraitConstraints()
            gridView.updateGridLetterColors()
            activateNotInWordListPortraitConstraints()
            activateKeyboardPortraitConstraints()
            keyboardView.updateSubviews(isLandscape: false)
            activateSendButtonPortraitConstraints()
            updateStatsButton(isLandscape: false)
            activateStatsViewPortraitConstraints()
            statsView.updateConstraints()
            updateNewGameButton(isLandscape: false)
            activateSuccessPortraitConstraints()
            activateDebugPortraitConstraints()
            updateGridButton(isLandscape: false)
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseIn) {
            self.layoutIfNeeded()
        } completion: { _ in
        }
    }
    
    
    // MARK: - ADD SUBVIEWS
    private func addSubviews() {
        addLogoView()
        addGridView()
        addKeyboardView()
        addSuccessView()
        addNotInWordListView()
        addSendButton()
        addNewGameButton()
        addStatsButton()
        addStatsView()
        addGridButton()
        addDebugView()
    }
    
    // MARK: - LOGO VIEW
    private func addLogoView() {
        logoView = LogoView(frame: .zero)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoView)
        activateLogoPortraitConstraints()
        addLongPressToLogoView()
    }
    
    // MARK: - LOGO LONG PRESS
    private func addLongPressToLogoView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressLogo(sender:)))
//        longPress.allowableMovement = 20
//        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        longPress.minimumPressDuration = 5
        logoView.addGestureRecognizer(longPress)
    }
    
    // MARK: - DID LONG PRESS LOGO
    @objc func didLongPressLogo(sender: UILongPressGestureRecognizer) {
        guard GameModel.shared.currentGuess == "ACSVP" else { return }
        showDebugView()
    }
    
    // MARK: - LOGO PORTRAIT CONSTRAINTS
    private func activateLogoPortraitConstraints() {
        NSLayoutConstraint.deactivate(logoPortraitConstraints)
        NSLayoutConstraint.deactivate(logoLandscapeConstraints)
        logoPortraitConstraints = [
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: Frame.Logo.upperPadding),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: Frame.Logo.size.width),
            logoView.heightAnchor.constraint(equalToConstant: Frame.Logo.size.height)
        ]
        NSLayoutConstraint.activate(logoPortraitConstraints)
    }
    
    // MARK: - LOGO LANDSCAPE CONSTRAINTS
    private func activateLogoLandscapeConstraints() {
        NSLayoutConstraint.deactivate(logoPortraitConstraints)
        NSLayoutConstraint.deactivate(logoLandscapeConstraints)
        logoLandscapeConstraints = [
            logoView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: Frame.Logo.size.width),
            logoView.heightAnchor.constraint(equalToConstant: Frame.Logo.size.height)
        ]
        NSLayoutConstraint.activate(logoLandscapeConstraints)
    }
    
    // MARK: - NOT IN WORD LIST
    private func addNotInWordListView() {
        notInWordListView = NotInWordListView(frame: .zero)
        notInWordListView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notInWordListView)
        activateNotInWordListPortraitConstraints()
    }
    
    // MARK: - NOT IN WORD LIST PORTRAIT CONSTRAINTS
    private func activateNotInWordListPortraitConstraints() {
        NSLayoutConstraint.deactivate(notInWordListPortraitConstraints)
        NSLayoutConstraint.deactivate(notInWordListLandscapeConstraints)
        notInWordListPortraitConstraints = [
            notInWordListView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 0),
            notInWordListView.centerXAnchor.constraint(equalTo: centerXAnchor),
            notInWordListView.widthAnchor.constraint(equalToConstant: Frame.NotInWordList.size.width),
            notInWordListView.heightAnchor.constraint(equalToConstant: Frame.NotInWordList.size.height)
        ]
        NSLayoutConstraint.activate(notInWordListPortraitConstraints)
    }
    
    // MARK: - NOT IN WORD LIST LANDSCAPE CONSTRAINTS
    private func activateNotInWordListLandscapeConstraints() {
        NSLayoutConstraint.deactivate(notInWordListPortraitConstraints)
        NSLayoutConstraint.deactivate(notInWordListLandscapeConstraints)
        notInWordListLandscapeConstraints = [
            notInWordListView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            notInWordListView.centerXAnchor.constraint(equalTo: gridView.centerXAnchor),
            notInWordListView.widthAnchor.constraint(equalToConstant: Frame.NotInWordList.size.width),
            notInWordListView.heightAnchor.constraint(equalToConstant: Frame.NotInWordList.size.height)
        ]
        NSLayoutConstraint.activate(notInWordListLandscapeConstraints)
    }
    
    // MARK: - GRID VIEW
    private func addGridView() {
        gridView = GridView(frame: .zero)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.gridDelegate = self
        addSubview(gridView)
        activateGridViewPortraitConstraints()
    }
        
    // MARK: - GRID VIEW PORTRAIT CONSTRAINTS
    private func activateGridViewPortraitConstraints() {
        NSLayoutConstraint.deactivate(gridViewPortraitConstraints)
        NSLayoutConstraint.deactivate(gridViewLandscapeConstraints)
        
        let gridWidth = frame.width * 0.7
        let scaledPadding = (Frame.padding / 3) * 2
        let size = Frame.Grid.size(gridWidth, scaledPadding: scaledPadding)
        
        gridViewPortraitConstraints = [
            gridView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: Frame.Grid.upperPadding),
            gridView.widthAnchor.constraint(equalToConstant: size.width),
            gridView.heightAnchor.constraint(equalToConstant: size.height)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? -UIScreen.main.bounds.width : 0
        let constraint = gridView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset)
        gridViewPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(gridViewPortraitConstraints)
    }
    
    // MARK: - GRID VIEW LANDSCAPE CONSTRAINTS
    private func activateGridViewLandscapeConstraints() {
        NSLayoutConstraint.deactivate(gridViewPortraitConstraints)
        NSLayoutConstraint.deactivate(gridViewLandscapeConstraints)

        let gridBoundsWidth = UIScreen.main.bounds.width / 3
        let scaledPadding = Frame.padding / 3
        let oneFifthSansPadding: CGFloat = (gridBoundsWidth / 5) - (scaledPadding * 6)
        let gridWidth = (oneFifthSansPadding * 5) + (scaledPadding * 6)
        let gridHeight = gridWidth + oneFifthSansPadding + (scaledPadding * 2)
        
        gridViewLandscapeConstraints = [
            gridView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            gridView.widthAnchor.constraint(equalToConstant: gridWidth),
            gridView.heightAnchor.constraint(equalToConstant: gridHeight)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? -UIScreen.main.bounds.width : 0
        let constraint = gridView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (Frame.padding * 4) + offset)
        gridViewLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(gridViewLandscapeConstraints)
    }
    
    // MARK: - SUCCESS VIEW
    private func addSuccessView() {
        successView = SuccessView(frame: .zero)
        successView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(successView)
        activateSuccessPortraitConstraints()
    }
    
    // MARK: - SUCCESS PORTRAIT CONSTRAINTS
    private func activateSuccessPortraitConstraints() {
        deactivateSuccessConstraints()
        successPortraitConstraints = [
            successView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: Frame.padding * 3),
            successView.widthAnchor.constraint(equalToConstant: Frame.Success.size.width),
            successView.heightAnchor.constraint(equalToConstant: Frame.Success.size.height)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? -UIScreen.main.bounds.width : 0
        let constraint = successView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset)
        successPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(successPortraitConstraints)
    }
    
    // MARK: - SUCCESS LANDSCAPE CONSTRAINTS
    private func activateSuccessLandscapeConstraints() {
        deactivateSuccessConstraints()
        successPortraitConstraints = [
            successView.centerXAnchor.constraint(equalTo: keyboardView.centerXAnchor),
            successView.widthAnchor.constraint(equalToConstant: Frame.Success.size.width),
            successView.heightAnchor.constraint(equalToConstant: Frame.Success.size.height)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = successView.topAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: (Frame.padding * 2) + offset)
        successPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(successPortraitConstraints)
    }
    
    // MARK: - DEACTIVATE SUCCESS CONSTRAINTS
    private func deactivateSuccessConstraints() {
        NSLayoutConstraint.deactivate(successPortraitConstraints)
        NSLayoutConstraint.deactivate(successLandscapeConstraints)
    }
    
    // MARK: - KEYBOARD VIEW
    private func addKeyboardView() {
        keyboardView = KeyboardView(frame: .zero)
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.keyboardDelegate = self
        addSubview(keyboardView)
        activateKeyboardPortraitConstraints()
        keyboardView.activatePortraitConstraints()
    }
    
    // MARK: - KEYBOARD PORTRAIT CONSTRAINTS
    private func activateKeyboardPortraitConstraints() {
        deactivateKeyboardConstraints()
        let letterSize = Frame.Keyboard.portraitLetterSize

        keyboardPortraitConstraints = [
            keyboardView.topAnchor.constraint(equalTo: gridView.bottomAnchor, constant: Frame.Grid.outerPadding),
            keyboardView.widthAnchor.constraint(equalTo: widthAnchor),
            keyboardView.heightAnchor.constraint(equalToConstant: (letterSize.height * 3) + (Frame.Keyboard.portraitLetterPadding * 4))
        ]
        let offset: CGFloat = appState == .stats || appState == .debug || !keyboardView.showing ? -UIScreen.main.bounds.width : 0
        let constraint = keyboardView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset)
        keyboardPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(keyboardPortraitConstraints)
    }
    
    // MARK: - KEYBOARD LANDSCAPE CONSTRAINTS
    private func activateKeyboardLandscapeConstraints() {
        deactivateKeyboardConstraints()
        let letterSize = Frame.Keyboard.landscapeLetterSize

        keyboardLandscapeConstraints = [
            keyboardView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: Frame.padding * 5),
            keyboardView.heightAnchor.constraint(equalToConstant: (letterSize.height * 3) + (Frame.Keyboard.landscapeLetterPadding * 4))
        ]
        let offset: CGFloat = appState == .stats || appState == .debug || !keyboardView.showing ? (UIScreen.main.bounds.width * 2) : 0
        let leadingConstraint =  keyboardView.leadingAnchor.constraint(equalTo: gridView.trailingAnchor, constant: (Frame.padding * 2) + offset)
        let trailingConstraint = keyboardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Frame.padding + offset)
        keyboardLandscapeConstraints.append(leadingConstraint)
        keyboardLandscapeConstraints.append(trailingConstraint)
        NSLayoutConstraint.activate(keyboardLandscapeConstraints)
    }
    
    // MARK: - DEACTIVATE KEYBOARD CONSTRAINTS
    private func deactivateKeyboardConstraints() {
        NSLayoutConstraint.deactivate(keyboardPortraitConstraints)
        NSLayoutConstraint.deactivate(keyboardLandscapeConstraints)
        keyboardPortraitConstraints.removeAll()
        keyboardLandscapeConstraints.removeAll()
    }
    
    // MARK: - SEND BUTTON
    private func addSendButton() {
        sendButton = UIButton(frame: .zero)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(didTapSendButton(sender:)), for: .touchUpInside)
        let image = UIImage().scaledSystemImage(
            named: "arrow.up.circle.fill",
            size: Frame.buttonSize,
            weight: .bold,
            color: .messagesBlue)
        sendButton.setImage(image, for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        addSubview(sendButton)
        activateSendButtonPortraitConstraints()
    }
    
    // MARK: - SEND BUTTON PORTRAIT CONSTRAINTS
    private func activateSendButtonPortraitConstraints() {
        deactivateSendButtonConstraints()
        sendButtonPortraitConstraints = [
            sendButton.topAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: (Frame.padding * 2)),
            sendButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            sendButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug || !sendButtonShowing ? (UIScreen.main.bounds.width * 2) : 0
        let constraint = sendButton.centerXAnchor.constraint(equalTo: keyboardView.centerXAnchor, constant: offset)
        sendButtonPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(sendButtonPortraitConstraints)
    }
    
    // MARK: - SEND BUTTON LANDSCAPE CONSTRAINTS
    func activateSendButtonLandscapeConstraints() {
        deactivateSendButtonConstraints()
        sendButtonLandscapeConstraints = [
            sendButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            sendButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
            sendButton.bottomAnchor.constraint(equalTo: keyboardView.topAnchor, constant: -Frame.padding)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug || !sendButtonShowing ? (UIScreen.main.bounds.width * 2) : 0
        let constraint = sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Frame.padding * 4) + offset)
        sendButtonLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(sendButtonLandscapeConstraints)
    }
    
    // MARK: - DEACTIVATE SEND BUTTON CONSTRAINTS
    private func deactivateSendButtonConstraints() {
        NSLayoutConstraint.deactivate(sendButtonPortraitConstraints)
        NSLayoutConstraint.deactivate(sendButtonLandscapeConstraints)
    }
    
    // MARK: - DID TAP SEND BUTTON
    @objc
    private func didTapSendButton(sender: UIButton) {
        playDelegate.didTapSendButton()
        disableKeyboard()
    }
    
    // MARK: - NEW GAME BUTTON
    private func addNewGameButton() {
        newGameButton = UIButton(frame: .zero)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.addTarget(self, action: #selector(didTapNewGameButton(sender:)), for: .touchUpInside)
        newGameButton.setImage(newGameButtonImage(), for: .normal)
        newGameButton.setTitleColor(.clear, for: .normal)
        addSubview(newGameButton)
        activateNewGameButtonPortraitConstraints()
    }
    
    // MARK: - UPDATE NEW GAME BUTTON
    private func updateNewGameButton(isLandscape: Bool) {
        if isLandscape {
            activateNewGameButtonLandscapeConstraints()
        } else {
            activateNewGameButtonPortraitConstraints()
        }
        newGameButton.setImage(newGameButtonImage(), for: .normal)
    }
    
    // MARK: - NEW GAME BUTTON IMAGE
    private func newGameButtonImage() -> UIImage {
        UIImage().scaledSystemImage(
            named: "arrow.clockwise.circle.fill",
            size: Frame.buttonSize,
            weight: .regular,
            color: .systemIconButton)
    }
    
    // MARK: - NEW GAME BUTTON PORTRAIT CONSTRAINTS
    private func activateNewGameButtonPortraitConstraints() {
        deactivateNewGameButtonConstraints()
        newGameButtonPortraitConstraints = [
            newGameButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
            newGameButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            newGameButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(Frame.padding * 13)),
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = newGameButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (Frame.padding * 2.5) - offset)
        newGameButtonPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(newGameButtonPortraitConstraints)
    }

    // MARK: - NEW GAME BUTTON LANDSCAPE CONSTRAINTS
    func activateNewGameButtonLandscapeConstraints() {
        deactivateNewGameButtonConstraints()
        newGameButtonLandscapeConstraints = [
            newGameButton.leadingAnchor.constraint(equalTo: gridView.trailingAnchor, constant: (Frame.padding * 2.5)),
            newGameButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
            newGameButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width)
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = newGameButton.topAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: (Frame.padding * 2) + offset)
        newGameButtonLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(newGameButtonLandscapeConstraints)
    }
    
    // MARK: - DEACTIVATE NEW GAME BUTTON CONSTRAINTS
    private func deactivateNewGameButtonConstraints() {
        NSLayoutConstraint.deactivate(newGameButtonPortraitConstraints)
        NSLayoutConstraint.deactivate(newGameButtonLandscapeConstraints)
    }
    
    // MARK: - DID TAP NEW GAME BUTTON
    @objc
    private func didTapNewGameButton(sender: UIButton) {
        resetGame()
        GamesCache.remove()
    }
    
    // MARK: - STATS BUTTON
    /// chart.bar.xaxis, chart.xyaxis.line, chart.bar.doc.horizontal, waveform.and.magnifyingglass
    private func addStatsButton() {
        statsButton = UIButton(frame: .zero)
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        statsButton.addTarget(self, action: #selector(didTapStatsButton(sender:)), for: .touchUpInside)
        statsButton.setImage(statsButtonImage(), for: .normal)
        statsButton.setTitleColor(.clear, for: .normal)
        addSubview(statsButton)
        activateStatsButtonPortraitConstraints()
    }
    
    // MARK: - UPDATE STATS BUTTON
    private func updateStatsButton(isLandscape: Bool) {
        if isLandscape {
            activateStatsButtonLandscapeConstraints()
        } else {
            activateStatsButtonPortraitConstraints()
        }
        statsButton.setImage(statsButtonImage(), for: .normal)
    }
    
    // MARK: - STATS BUTTON IMAGE
    private func statsButtonImage() -> UIImage {
        UIImage().scaledSystemImage(
            named: "books.vertical.fill",
            size: Frame.buttonSize,
            weight: .regular,
            color: .systemIconButton)
    }
    
    // MARK: - STATS BUTTON PORTRAIT CONSTRAINTS
    private func activateStatsButtonPortraitConstraints() {
        deactivateStatsButtonConstraints()
        statsButtonPortraitConstraints = [
            statsButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
            statsButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            statsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Frame.padding * 13),
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = statsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Frame.padding * 2.5) + offset)
        statsButtonPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(statsButtonPortraitConstraints)
    }

    // MARK: - STATS BUTTON LANDSCAPE CONSTRAINTS
    func activateStatsButtonLandscapeConstraints() {
        deactivateStatsButtonConstraints()
        statsButtonLandscapeConstraints = [
            statsButton.topAnchor.constraint(equalTo: keyboardView.bottomAnchor, constant: Frame.padding * 2),
            statsButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            statsButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
        ]
        let offset: CGFloat = appState == .stats || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = statsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(Frame.padding * 2) + offset)
        statsButtonLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(statsButtonLandscapeConstraints)
    }
    
    // MARK: - DID TAP STATS BUTTON
    @objc
    private func didTapStatsButton(sender: UIButton) {
        appState = .stats
        updateConstraints()
    }
    
    private func deactivateStatsButtonConstraints() {
        NSLayoutConstraint.deactivate(statsButtonPortraitConstraints)
        NSLayoutConstraint.deactivate(statsButtonLandscapeConstraints)
    }
    
    // MARK: - GRID BUTTON
    /// square.grid.3x3.middleright.filled, circle.grid.3x3.circle.fill
    private func addGridButton() {
        gridButton = UIButton(frame: .zero)
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        gridButton.addTarget(self, action: #selector(didTapGridButton(sender:)), for: .touchUpInside)
        gridButton.setImage(gridButtonImage(), for: .normal)
        gridButton.setTitleColor(.clear, for: .normal)
        addSubview(gridButton)
        activateGridButtonPortraitConstraints()
    }
    
    // MARK: - UPDATE GRID BUTTON
    private func updateGridButton(isLandscape: Bool) {
        if isLandscape {
            activateGridButtonLandscapeConstraints()
        } else {
            activateGridButtonPortraitConstraints()
        }
        gridButton.setImage(gridButtonImage(), for: .normal)
    }
    
    // MARK: - GRID BUTTON IMAGE
    private func gridButtonImage() -> UIImage {
        UIImage().scaledSystemImage(
            named: "gamecontroller.fill",
            size: Frame.buttonSize,
            weight: .regular,
            color: .systemIconButton)
    }
    
    // MARK: - GRID BUTTON PORTRAIT CONSTRAINTS
    private func activateGridButtonPortraitConstraints() {
        deactivateGridButtonConstraints()
        gridButtonPortraitConstraints = [
            gridButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
            gridButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            gridButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Frame.padding * 13),
        ]
        let offset: CGFloat = appState == .grid || appState == .debug ? -UIScreen.main.bounds.width : 0
        let constraint = gridButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (Frame.padding * 3) + offset)
        gridButtonPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(gridButtonPortraitConstraints)
    }
    
    // MARK: - GRID BUTTON LANDSCAPE CONSTRAINTS
    func activateGridButtonLandscapeConstraints() {
        deactivateGridButtonConstraints()
        gridButtonLandscapeConstraints = [
            gridButton.heightAnchor.constraint(equalToConstant: Frame.buttonSize.height),
            gridButton.widthAnchor.constraint(equalToConstant: Frame.buttonSize.width),
            gridButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Frame.padding)
        ]
        let offset: CGFloat = appState == .grid || appState == .debug ? -UIScreen.main.bounds.width : 0
        let constraint = gridButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (Frame.padding * 3) + offset)
        gridButtonLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(gridButtonLandscapeConstraints)
    }
    
    // MARK: - DEACTIVATE GRID BUTTON CONSTRAINTS
    private func deactivateGridButtonConstraints() {
        NSLayoutConstraint.deactivate(gridButtonPortraitConstraints)
        NSLayoutConstraint.deactivate(gridButtonLandscapeConstraints)
    }
    
    // MARK: - DID TAP GRID BUTTON
    @objc
    private func didTapGridButton(sender: UIButton) {
        appState = .grid
        updateConstraints()
    }
    
    // MARK: - UPDATE
    
    // MARK: - STATS VIEW
    private func addStatsView() {
        statsView = StatsView(frame: .zero)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsView)
        activateStatsViewPortraitConstraints()
    }
    
    // MARK: - STATS VIEW PORTRAIT CONSTRAINTS
    private func activateStatsViewPortraitConstraints() {
        deactivateStatsViewConstraints()
        statsViewPortraitConstraints = [
            statsView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: Frame.Grid.upperPadding),
            statsView.widthAnchor.constraint(equalTo: widthAnchor),
            statsView.heightAnchor.constraint(equalTo: heightAnchor)
        ]
        let offset: CGFloat = appState == .grid || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = statsView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset)
        statsViewPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(statsViewPortraitConstraints)
    }
    
    // MARK: - STATS VIEW LANDSCAPE CONSTRAINTS
    private func activateStatsViewLandscapeConstraints() {
        deactivateStatsViewConstraints()
        statsViewLandscapeConstraints = [
            statsView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: Frame.padding),
            statsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            statsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        ]
        let offset: CGFloat = appState == .grid || appState == .debug ? UIScreen.main.bounds.width : 0
        let constraint = statsView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset)
        statsViewLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(statsViewLandscapeConstraints)
    }
    
    // MARK: - DEACTIVATE STATS VIEW CONSTRAINTS
    private func deactivateStatsViewConstraints() {
        NSLayoutConstraint.deactivate(statsViewPortraitConstraints)
        NSLayoutConstraint.deactivate(statsViewLandscapeConstraints)
    }
    
    // MARK: - DEBUG VIEW
    private func addDebugView() {
        debugView = DebugView(frame: .zero)
        debugView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(debugView)
        activateDebugPortraitConstraints()
    }
    
    // MARK: - DEBUG VIEW PORTRAIT CONSTRAINTS
    private func activateDebugPortraitConstraints() {
        deactivateDebugConstraints()
        debugViewPortraitConstraints = [
            debugView.leadingAnchor.constraint(equalTo: leadingAnchor),
            debugView.trailingAnchor.constraint(equalTo: trailingAnchor),
            debugView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        let offset: CGFloat = appState == .debug ? 0 : UIScreen.main.bounds.height
        let constraint = debugView.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        debugViewPortraitConstraints.append(constraint)
        NSLayoutConstraint.activate(debugViewPortraitConstraints)
    }
    
    // MARK: - DEBUG VIEW LANDSCAPE CONSTRAINTS
    private func activateDebugLandscapeConstraints() {
        deactivateDebugConstraints()
        debugViewLandscapeConstraints = [
            debugView.leadingAnchor.constraint(equalTo: leadingAnchor),
            debugView.trailingAnchor.constraint(equalTo: trailingAnchor),
            debugView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        let offset: CGFloat = appState == .debug ? 0 : UIScreen.main.bounds.height
        let constraint = debugView.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        debugViewLandscapeConstraints.append(constraint)
        NSLayoutConstraint.activate(debugViewLandscapeConstraints)
    }

    
    // MARK: - DEACTIVATE DEBUG CONSTRAINTS
    private func deactivateDebugConstraints() {
        NSLayoutConstraint.deactivate(debugViewPortraitConstraints)
        NSLayoutConstraint.deactivate(debugViewLandscapeConstraints)
    }
    
    func hideDebugView() {
        appState = .grid
        updateConstraints()
    }
    
    func showDebugView() {
        appState = .debug
        updateConstraints()
    }
    
    // MARK: - SHOW THE WIN
    func showTheWin(currentGame: Game) {
        
        // disable keyboard
        keyboardView.isUserInteractionEnabled = false
        
        // show success view
        showSuccessView()
        
        // update stats
        if let currentGame = GameModel.shared.currentGame {
            GameModel.shared.updateGames(with: currentGame)
        }
        
        // show new game button
        if GameModel.shared.isLandscape {
            activateNewGameButtonLandscapeConstraints()
        } else {
            activateNewGameButtonPortraitConstraints()
        }
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            self.layoutIfNeeded()
        } completion: { _ in
        }
        
        // make letters jump for joy
        gridView.jumpForJoy()
    }
    
    // MARK: - SHOW THE LOSS
    func showTheLoss(currentGame: Game) {
        keyboardView.isUserInteractionEnabled = false
        showAnswer()
        if let currentGame = GameModel.shared.currentGame {
            GameModel.shared.updateGames(with: currentGame)
        }
        if GameModel.shared.isLandscape {
            activateNewGameButtonLandscapeConstraints()
        } else {
            activateNewGameButtonPortraitConstraints()
        }
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            self.layoutIfNeeded()
        } completion: { _ in
        }
    }
    
    // MARK: - RESET
    func resetGame() {
        GameModel.shared.resetGame {
            self.gridView.resetRows()
            self.keyboardView.resetKeyboard()
            self.successView.isHidden = true
        }
    }
    
    // MARK: - DEACTIVATE CONSTRAINTS
    func deactivateConstraints(for appSection: AppSection) {
        var deactivationConstraints: [[NSLayoutConstraint]] = []
        
        switch appSection {
        case .logoImageView:
            deactivationConstraints.append(logoPortraitConstraints)
            deactivationConstraints.append(logoLandscapeConstraints)
        case .notInWordListView:
            deactivationConstraints.append(notInWordListPortraitConstraints)
            deactivationConstraints.append(notInWordListLandscapeConstraints)
        case .gridView:
            deactivationConstraints.append(gridViewPortraitConstraints)
            deactivationConstraints.append(gridViewLandscapeConstraints)
        case .successView:
            deactivationConstraints.append(successPortraitConstraints)
        case .keyboardView:
            deactivationConstraints.append(keyboardPortraitConstraints)
            deactivationConstraints.append(keyboardLandscapeConstraints)
        case .sendButton:
            deactivationConstraints.append(sendButtonPortraitConstraints)
            deactivationConstraints.append(sendButtonLandscapeConstraints)
        case .statsButton:
            deactivationConstraints.append(statsButtonPortraitConstraints)
            deactivationConstraints.append(statsButtonLandscapeConstraints)
        case .statsView:
            deactivationConstraints.append(statsViewPortraitConstraints)
            deactivationConstraints.append(statsViewLandscapeConstraints)
        case .gridButton:
            deactivationConstraints.append(gridButtonPortraitConstraints)
            deactivationConstraints.append(gridButtonLandscapeConstraints)
        case .newGameButton:
            deactivationConstraints.append(newGameButtonPortraitConstraints)
            deactivationConstraints.append(newGameButtonLandscapeConstraints)
        case .all:
            deactivationConstraints.append(logoPortraitConstraints)
            deactivationConstraints.append(logoLandscapeConstraints)
            deactivationConstraints.append(notInWordListPortraitConstraints)
            deactivationConstraints.append(notInWordListLandscapeConstraints)
            deactivationConstraints.append(gridViewPortraitConstraints)
            deactivationConstraints.append(gridViewLandscapeConstraints)
            deactivationConstraints.append(successPortraitConstraints)
            deactivationConstraints.append(keyboardPortraitConstraints)
            deactivationConstraints.append(keyboardLandscapeConstraints)
            deactivationConstraints.append(sendButtonPortraitConstraints)
            deactivationConstraints.append(sendButtonLandscapeConstraints)
            deactivationConstraints.append(statsButtonPortraitConstraints)
            deactivationConstraints.append(statsButtonLandscapeConstraints)
            deactivationConstraints.append(statsViewPortraitConstraints)
            deactivationConstraints.append(statsViewLandscapeConstraints)
            deactivationConstraints.append(gridButtonPortraitConstraints)
            deactivationConstraints.append(gridButtonLandscapeConstraints)
            deactivationConstraints.append(newGameButtonPortraitConstraints)
            deactivationConstraints.append(newGameButtonLandscapeConstraints)
        }
        
        for constraints in deactivationConstraints {
            NSLayoutConstraint.deactivate(constraints)
        }
    }
}

extension PlayView: KeyboardDelegate {
    
    // MARK: - DID TAP LETTER
    func didTapLetter(_ letter: String) {
        guard let currentGame = GameModel.shared.currentGame else { return }
        switch currentGame.currentLetter {
        case .a0:
            GameModel.shared.currentGame?.guessNumber = .first
            gridView.a1.updateLetter(with: letter)
            gridView.a1.growAndShrink {
                self.gridView.a1.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .a1
        case .a1:
            gridView.a2.updateLetter(with: letter)
            gridView.a2.growAndShrink {
                self.gridView.a2.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .a2
        case .a2:
            gridView.a3.updateLetter(with: letter)
            gridView.a3.growAndShrink {
                self.gridView.a3.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .a3
        case .a3:
            gridView.a4.updateLetter(with: letter)
            gridView.a4.growAndShrink {
                self.gridView.a4.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .a4
        case .a4:
            gridView.a5.updateLetter(with: letter)
            gridView.a5.growAndShrink {
                self.gridView.a5.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .a5
        case .b0:
            GameModel.shared.currentGame?.guessNumber = .second
            gridView.b1.updateLetter(with: letter)
            gridView.b1.growAndShrink {
                self.gridView.b1.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .b1
        case .b1:
            gridView.b2.updateLetter(with: letter)
            gridView.b2.growAndShrink {
                self.gridView.b2.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .b2
        case .b2:
            gridView.b3.updateLetter(with: letter)
            gridView.b3.growAndShrink {
                self.gridView.b3.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .b3
        case .b3:
            gridView.b4.updateLetter(with: letter)
            gridView.b4.growAndShrink {
                self.gridView.b4.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .b4
        case .b4:
            gridView.b5.updateLetter(with: letter)
            gridView.b5.growAndShrink {
                self.gridView.b5.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .b5
        case .c0:
            GameModel.shared.currentGame?.guessNumber = .third
            gridView.c1.updateLetter(with: letter)
            gridView.c1.growAndShrink {
                self.gridView.c1.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .c1
        case .c1:
            gridView.c2.updateLetter(with: letter)
            gridView.c2.growAndShrink {
                self.gridView.c2.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .c2
        case .c2:
            gridView.c3.updateLetter(with: letter)
            gridView.c3.growAndShrink {
                self.gridView.c3.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .c3
        case .c3:
            gridView.c4.updateLetter(with: letter)
            gridView.c4.growAndShrink {
                self.gridView.c4.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .c4
        case .c4:
            gridView.c5.updateLetter(with: letter)
            gridView.c5.growAndShrink {
                self.gridView.c5.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .c5
        case .d0:
            GameModel.shared.currentGame?.guessNumber = .fourth
            gridView.d1.updateLetter(with: letter)
            gridView.d1.growAndShrink {
                self.gridView.d1.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .d1
        case .d1:
            gridView.d2.updateLetter(with: letter)
            gridView.d2.growAndShrink {
                self.gridView.d2.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .d2
        case .d2:
            gridView.d3.updateLetter(with: letter)
            gridView.d3.growAndShrink {
                self.gridView.d3.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .d3
        case .d3:
            gridView.d4.updateLetter(with: letter)
            gridView.d4.growAndShrink {
                self.gridView.d4.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .d4
        case .d4:
            gridView.d5.updateLetter(with: letter)
            gridView.d5.growAndShrink {
                self.gridView.d5.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .d5
        case .e0:
            GameModel.shared.currentGame?.guessNumber = .fifth
            gridView.e1.updateLetter(with: letter)
            gridView.e1.growAndShrink {
                self.gridView.e1.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .e1
        case .e1:
            gridView.e2.updateLetter(with: letter)
            gridView.e2.growAndShrink {
                self.gridView.e2.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .e2
        case .e2:
            gridView.e3.updateLetter(with: letter)
            gridView.e3.growAndShrink {
                self.gridView.e3.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .e3
        case .e3:
            gridView.e4.updateLetter(with: letter)
            gridView.e4.growAndShrink {
                self.gridView.e4.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .e4
        case .e4:
            gridView.e5.updateLetter(with: letter)
            gridView.e5.growAndShrink {
                self.gridView.e5.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .e5
        case .f0:
            GameModel.shared.currentGame?.guessNumber = .sixth
            gridView.f1.updateLetter(with: letter)
            gridView.f1.growAndShrink {
                self.gridView.f1.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .f1
        case .f1:
            gridView.f2.updateLetter(with: letter)
            gridView.f2.growAndShrink {
                self.gridView.f2.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .f2
        case .f2:
            gridView.f3.updateLetter(with: letter)
            gridView.f3.growAndShrink {
                self.gridView.f3.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .f3
        case .f3:
            gridView.f4.updateLetter(with: letter)
            gridView.f4.growAndShrink {
                self.gridView.f4.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .f4
        case .f4:
            gridView.f5.updateLetter(with: letter)
            gridView.f5.growAndShrink {
                self.gridView.f5.setBorderActive()
            }
            GameModel.shared.currentGuess += letter
            GameModel.shared.currentGame?.currentLetter = .f5
        case .a5, .b5, .c5, .d5, .e5, .f5: ()
        }
    }
    
    // MARK: - DID TAP ENTER
    func didTapEnter() {
        guard let currentGame = GameModel.shared.currentGame else { return }
        guard GameModel.shared.currentGuess.count == 5 else { return }
        
        guard gridView.wordIsInList() else { return }
        
        GameModel.shared.populateGuessLetterCountDictionary(with: GameModel.shared.currentGuess) {
            self.gridView.updateRowsFromEnter {
                if GameModel.shared.currentGuess.lowercased() != currentGame.answer {
                    switch currentGame.currentLetter {
                    case .a5:
                        GameModel.shared.currentGame?.guess1 = GameModel.shared.currentGuess
                        GameModel.shared.currentGame?.currentLetter = .b0
                    case .b5:
                        GameModel.shared.currentGame?.guess2 = GameModel.shared.currentGuess
                        GameModel.shared.currentGame?.currentLetter = .c0
                    case .c5:
                        GameModel.shared.currentGame?.guess3 = GameModel.shared.currentGuess
                        GameModel.shared.currentGame?.currentLetter = .d0
                    case .d5:
                        GameModel.shared.currentGame?.guess4 = GameModel.shared.currentGuess
                        GameModel.shared.currentGame?.currentLetter = .e0
                    case .e5:
                        GameModel.shared.currentGame?.guess5 = GameModel.shared.currentGuess
                        GameModel.shared.currentGame?.currentLetter = .f0
                    case .f5:
                        GameModel.shared.currentGame?.guess6 = GameModel.shared.currentGuess
                        self.showAnswer()
                        GameModel.shared.currentGame?.state = .lost
                    default: ()
                    }
                }
                
                if GameModel.shared.currentGuess.lowercased() == GameModel.shared.currentGame?.answer {
                    self.showSuccessView()
                    self.gridView.jumpForJoy()
                    GameModel.shared.currentGame?.state = .won
                }
                
                if let updatedCurrentGame = GameModel.shared.currentGame,
                   (updatedCurrentGame.state == .won || updatedCurrentGame.state == .lost) {
                    GameModel.shared.updateGames(with: updatedCurrentGame)
                }
                
                GameModel.shared.currentGuess = ""
            }
        }
    }
    
    // MARK: - DID TAP BACKSPACE
    func didTapBackspace() {
        guard let currentGame = GameModel.shared.currentGame else { return }
        
        if !GameModel.shared.currentGuess.isEmpty {
            GameModel.shared.currentGuess.removeLast()
        }
        
        switch currentGame.currentLetter {
        case .a1:
            gridView.a1.updateLetter(with: "")
            gridView.a1.setBorderInactive()
            GameModel.shared.currentGame?.currentLetter = .a0
        case .a2:
            gridView.a2.updateLetter(with: "")
            gridView.a2.setBorderInactive()
            gridView.a1.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .a1
        case .a3:
            gridView.a3.updateLetter(with: "")
            gridView.a3.setBorderInactive()
            gridView.a2.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .a2
        case .a4:
            gridView.a4.updateLetter(with: "")
            gridView.a4.setBorderInactive()
            gridView.a3.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .a3
        case .a5:
            gridView.a5.updateLetter(with: "")
            gridView.a5.setBorderInactive()
            gridView.a4.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .a4
        case .b1:
            gridView.b1.updateLetter(with: "")
            gridView.b1.setBorderInactive()
            GameModel.shared.currentGame?.currentLetter = .b0
        case .b2:
            gridView.b2.updateLetter(with: "")
            gridView.b2.setBorderInactive()
            gridView.b1.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .b1
        case .b3:
            gridView.b3.updateLetter(with: "")
            gridView.b3.setBorderInactive()
            gridView.b2.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .b2
        case .b4:
            gridView.b4.updateLetter(with: "")
            gridView.b4.setBorderInactive()
            gridView.b3.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .b3
        case .b5:
            gridView.b5.updateLetter(with: "")
            gridView.b5.setBorderInactive()
            gridView.b4.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .b4
        case .c1:
            gridView.c1.updateLetter(with: "")
            gridView.c1.setBorderInactive()
            GameModel.shared.currentGame?.currentLetter = .c0
        case .c2:
            gridView.c2.updateLetter(with: "")
            gridView.c2.setBorderInactive()
            gridView.c1.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .c1
        case .c3:
            gridView.c3.updateLetter(with: "")
            gridView.c3.setBorderInactive()
            gridView.c2.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .c2
        case .c4:
            gridView.c4.updateLetter(with: "")
            gridView.c4.setBorderInactive()
            gridView.c3.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .c3
        case .c5:
            gridView.c5.updateLetter(with: "")
            gridView.c5.setBorderInactive()
            gridView.c4.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .c4
        case .d1:
            gridView.d1.updateLetter(with: "")
            gridView.d1.setBorderInactive()
            GameModel.shared.currentGame?.currentLetter = .d0
        case .d2:
            gridView.d2.updateLetter(with: "")
            gridView.d2.setBorderInactive()
            gridView.d1.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .d1
        case .d3:
            gridView.d3.updateLetter(with: "")
            gridView.d3.setBorderInactive()
            gridView.d2.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .d2
        case .d4:
            gridView.d4.updateLetter(with: "")
            gridView.d4.setBorderInactive()
            gridView.d3.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .d3
        case .d5:
            gridView.d5.updateLetter(with: "")
            gridView.d5.setBorderInactive()
            gridView.d4.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .d4
        case .e1:
            gridView.e1.updateLetter(with: "")
            gridView.e1.setBorderInactive()
            GameModel.shared.currentGame?.currentLetter = .e0
        case .e2:
            gridView.e2.updateLetter(with: "")
            gridView.e2.setBorderInactive()
            gridView.e1.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .e1
        case .e3:
            gridView.e3.updateLetter(with: "")
            gridView.e3.setBorderInactive()
            gridView.e2.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .e2
        case .e4:
            gridView.e4.updateLetter(with: "")
            gridView.e4.setBorderInactive()
            gridView.e3.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .e3
        case .e5:
            gridView.e5.updateLetter(with: "")
            gridView.e5.setBorderInactive()
            gridView.e4.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .e4
        case .f1:
            gridView.f1.updateLetter(with: "")
            gridView.f1.setBorderInactive()
            GameModel.shared.currentGame?.currentLetter = .f0
        case .f2:
            gridView.f2.updateLetter(with: "")
            gridView.f2.setBorderInactive()
            gridView.f1.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .f1
        case .f3:
            gridView.f3.updateLetter(with: "")
            gridView.f3.setBorderInactive()
            gridView.f2.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .f2
        case .f4:
            gridView.f4.updateLetter(with: "")
            gridView.f4.setBorderInactive()
            gridView.f3.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .f3
        case .f5:
            gridView.f5.updateLetter(with: "")
            gridView.f5.setBorderInactive()
            gridView.f4.setBorderActive()
            GameModel.shared.currentGame?.currentLetter = .f4
        default: ()
        }
    }
}

// MARK: - GRID DELEGATE
extension PlayView: GridDelegate {
    func showNotInWordListView() {
        notInWordListView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.notInWordListView.isHidden = true
        }
    }
    
    func showSuccessView() {
        successView.isHidden = false
    }
    
    func showAnswer() {
        successView.showAnswer()
        successView.isHidden = false
    }
    
    func disableKeyboard() {
        keyboardView.isUserInteractionEnabled = false
    }
    
    func setKeyToGreen(for guessLetter: String) {
        keyboardView.setKeyToGreen(for: guessLetter)
    }
    
    func setKeyToGray(for guessLetter: String) {
        keyboardView.setKeyToGray(for: guessLetter)
    }
    
    func setKeyToYellow(for guessLetter: String) {
        keyboardView.setKeyToYellow(for: guessLetter)
    }
    
    func showSendButton() {
        sendButtonShowing = true
        if GameModel.shared.isLandscape {
            activateSendButtonLandscapeConstraints()
        } else {
            activateSendButtonPortraitConstraints()
        }
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseIn) {
            self.layoutIfNeeded()
        } completion: { _ in
        }
    }
}

// MARK: - LONG PRESS DELEGATE
extension PlayView: UIGestureRecognizerDelegate {}
