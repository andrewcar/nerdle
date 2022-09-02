//
//  TicTacToeModel.swift
//  BoredGames MessagesExtension
//
//  Created by Andrew Carvajal on 8/24/22.
//

import Foundation

protocol TTTGameDelegate {
    func didUpdateGame()
}

class TicTacToeModel: NSObject {
    static let shared = TicTacToeModel()
    var tttGameDelegate: TTTGameDelegate!
    var games = TicTacToeGames(value: [])
    var currentTTTGame: TicTacToeGame?
    var ticTacToeState: TicTacToeState = .grid
    var resetAvailable: Bool = true
    
    // MARK: - TAG FOR SQUARE
    func tag(for square: TicTacToeSquare) -> Int {
        switch square {
        case .a1:
            return 1
        case .a2:
            return 2
        case .a3:
            return 3
        case .b1:
            return 4
        case .b2:
            return 5
        case .b3:
            return 6
        case .c1:
            return 7
        case .c2:
            return 8
        case .c3:
            return 9
        }
    }
    
    // MARK: - SQUARE FOR TAG
    func square(for tag: Int) -> TicTacToeSquare {
        switch tag {
        case 1:
            return .a1
        case 2:
            return .a2
        case 3:
            return .a3
        case 4:
            return .b1
        case 5:
            return .b2
        case 6:
            return .b3
        case 7:
            return .c1
        case 8:
            return .c2
        case 9:
            return .c3
        default:
            return .a1
        }
    }
    
    // MARK: - SYMBOL FOR TURN
    func emojiString(for turn: Turn) -> String {
        let x = "X"
        let o = "O"
        switch turn {
        case .first:
            return x
        case .second:
            return o
        case .third:
            return x
        case .fourth:
            return o
        case .fifth:
            return x
        case .sixth:
            return o
        case .seventh:
            return x
        case .eighth:
            return o
        case .ninth:
            return x
        }
    }
    
    // MARK: - ADVANCE TURN NUMBER
    func advanceTurnNumber() {
        switch currentTTTGame?.turnNumber {
        case .first:
            currentTTTGame?.turnNumber = Turn(rawValue: "second")
        case .second:
            currentTTTGame?.turnNumber = Turn(rawValue: "third")
        case .third:
            currentTTTGame?.turnNumber = Turn(rawValue: "fourth")
        case .fourth:
            currentTTTGame?.turnNumber = Turn(rawValue: "fifth")
        case .fifth:
            currentTTTGame?.turnNumber = Turn(rawValue: "sixth")
        case .sixth:
            currentTTTGame?.turnNumber = Turn(rawValue: "seventh")
        case .seventh:
            currentTTTGame?.turnNumber = Turn(rawValue: "eighth")
        case .eighth:
            currentTTTGame?.turnNumber = Turn(rawValue: "ninth")
        default: ()
        }
    }
    
    // MARK: - UPDATE GAMES
    func updateGames() {
        GamesCache.saveTTTGames(games)
        tttGameDelegate?.didUpdateGame()
    }
    
    func gameIsNotDuplicate(_ game: TicTacToeGame) -> Bool {
        !games.value.contains(where: { aGame in
            aGame.id == game.id
        })
    }
    
    func incrementPlayedCount(with game: TicTacToeGame) {
        guard gameIsNotDuplicate(game) else { return }
        
        games.gameCount += 1
        games.value.append(game)
    }
    
    func incrementCatsGameCount(with game: TicTacToeGame) {
        guard gameIsNotDuplicate(game) else { return }
        games.catsGameCount += 1
    }
    
    func incrementWinCountAndStreak(with game: TicTacToeGame) {
        guard gameIsNotDuplicate(game) else { return }

        games.winCount += 1
        if games.streakCount == games.longestStreak {
            games.longestStreak += 1
        }
        games.streakCount += 1
    }
    
    func incrementLossCountAndResetStreak(with game: TicTacToeGame) {
        guard gameIsNotDuplicate(game) else { return }

        games.lossCount += 1
        games.streakCount = 0
    }
    
    // MARK: - RESET GAME
    func resetGame(completion: @escaping () -> ()) {
        currentTTTGame = TicTacToeGame()
        completion()
    }
}