//
//  LoggerInvoker.swift
//  XO-game
//
//  Created by aprirez on 12/27/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation


// MARK: - Invoker

internal final class LoggerInvoker {
    
    // MARK: Singleton
    internal static let shared = LoggerInvoker()
    
    // MARK: Private properties
    private let logger = Logger()
    
    private let batchSize = 1 // 10
    
    private var commands: [LogCommand] = []
    
    // MARK: Internal
    internal func addLogCommand(_ command: LogCommand) {
        self.commands.append(command)
        self.executeCommandsIfNeeded()
    }
    
    // MARK: Private
    private func executeCommandsIfNeeded() {
        guard self.commands.count >= batchSize else {
            return
        }

        self.commands.forEach { self.logger.writeMessageToLog($0.logMessage) }
        self.commands = []
    }
}
