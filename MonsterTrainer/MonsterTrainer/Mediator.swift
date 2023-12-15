//
//  Mediator.swift
//  MonsterTrainer
//
//  Created by loaner on 12/10/23.
//
// Code for mediator from this stack overflow post: https://stackoverflow.com/questions/28706877/how-can-you-reload-a-viewcontroller-after-dismissing-a-modally-presented-view-co

import UIKit

// Used to tell when the user has selected a starter and seemlessly update the main menu
protocol ModalTransitionListener {
    func popoverDismissed()
}

class Mediator: NSObject {
    class var instance: Mediator {
            struct Static {
                static let instance: Mediator = Mediator()
            }
            return Static.instance
        }

    private var listener: ModalTransitionListener?

//    private override init() {
//
//    }

    func setListener(listener: ModalTransitionListener) {
        self.listener = listener
    }

    func sendPopoverDismissed(modelChanged: Bool) {
        listener?.popoverDismissed()
    }
}
