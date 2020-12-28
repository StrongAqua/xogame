//
//  PlayersActionsInvoker.swift
//  XO-game
//
//  Created by aprirez on 12/29/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class PlayerInputCommand {
    public let player: Player
    public let position: GameboardPosition

    init(player: Player, position: GameboardPosition) {
        self.player = player
        self.position = position
    }
    
    func execute(gameboardView: GameboardView, gameboard: Gameboard) {
        let mark: MarkView =
            player == Player.first
            ? XView()
            : OView()

        gameboard.setPlayer(player, at: position)
        gameboardView.placeMarkView(mark.copy(), at: position)
    }
}

public class PlayersActionsInvoker {
    
    public private(set) var playersCommands: [Player: [PlayerInputCommand]] = [:]
    private var currentPlayer = Player.first

    func addCommand(command: PlayerInputCommand) {
        if playersCommands[command.player] == nil {
            playersCommands[command.player] = []
        }
        playersCommands[command.player]?.append(command)
    }
    
    func execute(gameboardView: GameboardView, gameboard: Gameboard) {
        gameboard.clear()
        gameboardView.clear()
        let referee = Referee(gameboard: gameboard)
        while true {
            guard playersCommands[currentPlayer]?.count ?? 0 > 0
            else {
                break
            }
            if let command = playersCommands[currentPlayer]?.remove(at: 0) {
                command.execute(gameboardView: gameboardView, gameboard: gameboard)
                if referee.determineWinner() != nil || referee.isDraw() {
                    break
                }
                currentPlayer = currentPlayer.next
            } else {break}
        }
    }
}
