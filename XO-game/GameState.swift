//
//  GameState.swift
//  XO-game
//
//  Created by aprirez on 12/27/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation


public protocol GameState {
    
    var isCompleted: Bool { get }
    
    func begin(_ completion: () -> Void)
    func addMark(at position: GameboardPosition)
}

public class PlayerInputState: GameState {
    
    public private(set) var isCompleted = false
    
    public let player: Player
    public let markViewPrototype: MarkView

    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin(_: () -> Void) {
        switch self.player {
            case .first:
                self.gameViewController?.firstPlayerTurnLabel.isHidden = false
                self.gameViewController?.secondPlayerTurnLabel.isHidden = true
            case .second:
                self.gameViewController?.firstPlayerTurnLabel.isHidden = true
                self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        Log(.playerInput(player: self.player, position: position))

        guard let gameboardView = self.gameboardView,
            gameboardView.canPlaceMarkView(at: position)
        else { return }
        
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(self.markViewPrototype.copy(), at: position)

        setCompleted()
    }
    
    fileprivate func setCompleted() {
        self.isCompleted = true
    }
}

public class ComputerInputState: PlayerInputState {
    
    public override func begin(_ completion: () -> Void) {
        super.begin(completion)

        guard let gameboard = self.gameboard else {return}
        let freeCells = gameboard.freeCells()
        guard freeCells.count > 0 else {return}
        let cell = Int.random(in: 0 ..< freeCells.count)
        guard let onSelectPosition = self.gameboardView?.onSelectPosition
        else {return}

        onSelectPosition(freeCells[cell])
    }
        
}

public class SequenceInputState: PlayerInputState {
    
    public private(set) var count = 0
    public private(set) var commandsInvoker: PlayersActionsInvoker?
    
    func setInvoker(commandsInvoker: PlayersActionsInvoker) {
        self.commandsInvoker = commandsInvoker
    }

    override public func addMark(at position: GameboardPosition) {
        guard let commandsInvoker = commandsInvoker else {
            debugPrint("ERROR: Please sir, set invoker")
            return
        }
        guard count < 5 else {
            self.setCompleted()
            return
        }

        Log(.playerInput(player: self.player, position: position))
        
        guard let gameboardView = self.gameboardView,
            gameboardView.canPlaceMarkView(at: position)
        else { return }

        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(self.markViewPrototype.copy(), at: position)

        commandsInvoker.addCommand(command: PlayerInputCommand(player: player, position: position))
        count += 1

        if count >= 5 {
            self.gameboard?.clear()
            self.gameboardView?.clear()
            self.setCompleted()
            return
        }
    }
}

public class SimulateInputState: GameState {
    public var isCompleted: Bool = false
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    private(set) weak var actionsInvoker: PlayersActionsInvoker?

    init(gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView,
         actionsInvoker: PlayersActionsInvoker)
    {
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.actionsInvoker = actionsInvoker
    }

    public func begin(_ completion: () -> Void) {
        guard let view = self.gameboardView,
              let gameboard = self.gameboard else {return}

        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true

        actionsInvoker?.execute(gameboardView: view, gameboard: gameboard)
        self.isCompleted = true
        completion()
    }
    
    public func addMark(at position: GameboardPosition) {
        // do nothing
    }
}
