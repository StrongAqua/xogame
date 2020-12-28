//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    private let gameboard = Gameboard()
    
    public var withHuman: Bool = false
    public var sequentalMode: Bool = false
    
    private var playerActionsInvoker = PlayersActionsInvoker()

    private var currentState: GameState! {
        didSet {
            self.currentState.begin() {
                self.goToNextState()
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    private func goToFirstState() {
        let player = Player.first
        gameboard.clear()
        gameboardView.clear()
        if sequentalMode {
            let sequenceState = SequenceInputState(
                player: player,
                markViewPrototype: player.markViewPrototype,
                gameViewController: self,
                gameboard: gameboard,
                gameboardView: gameboardView
            )
            sequenceState.setInvoker(commandsInvoker: playerActionsInvoker)
            self.currentState = sequenceState
        } else {
            self.currentState = PlayerInputState(
                player: player,
                markViewPrototype: player.markViewPrototype,
                gameViewController: self,
                gameboard: gameboard,
                gameboardView: gameboardView
            )
        }
    }

    private func goToNextState() {

        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }

        if self.referee.isDraw() {
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }

        if sequentalMode && (nil != currentState as? SimulateInputState) {
            // simulation is done with no winner
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }

        if sequentalMode {
            if let playerInputState = currentState as? SequenceInputState {
                let player = playerInputState.player.next
                if player == Player.first {
                    // start simulation
                    self.currentState = SimulateInputState(
                        gameViewController: self,
                        gameboard: gameboard,
                        gameboardView: gameboardView,
                        actionsInvoker: playerActionsInvoker
                    )
                    return
                }
                let sequenceState = SequenceInputState(
                    player: player,
                    markViewPrototype: player.markViewPrototype,
                    gameViewController: self,
                    gameboard: gameboard,
                    gameboardView: gameboardView
                )
                sequenceState.setInvoker(commandsInvoker: playerActionsInvoker)
                self.currentState = sequenceState
            }
        } else {
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                if player == Player.first || withHuman {
                    self.currentState = PlayerInputState(
                        player: player,
                        markViewPrototype: player.markViewPrototype,
                        gameViewController: self,
                        gameboard: gameboard,
                        gameboardView: gameboardView
                    )
                } else {
                    self.currentState = ComputerInputState(
                        player: player,
                        markViewPrototype: player.markViewPrototype,
                        gameViewController: self,
                        gameboard: gameboard,
                        gameboardView: gameboardView
                    )
                }
            }
        }
    }

    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        goToFirstState()
    }
}

