//
//  Logger.swift
//  XO-game
//
//  Created by aprirez on 12/27/20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

// MARK: - Receiver
final class Logger {
    
    func writeMessageToLog(_ message: String) {
        /// Здесь должна быть реализация записи сообщения в лог.
        /// Для простоты примера паттерна не вдаемся в эту реализацию,
        /// а просто печатаем текст в консоль.
        print(message)
    }
}
