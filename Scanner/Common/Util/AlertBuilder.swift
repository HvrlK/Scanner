//
//  AlertBuilder.swift
//  Scanner
//
//  Created by Vitalii Havryliuk on 4/7/19.
//  Copyright © 2019 Vitalii Havryliuk. All rights reserved.
//

import UIKit

class AlertBuilder {
    
    private enum UIAlertControllerKeys: String {
        case attributedMessage
    }
    
    init(_ vc: UIViewController) {
        self.vc = vc
    }
    
    private weak var vc: UIViewController?
    
    private var title: String?
    private var message: String?
    private var attributedMessage: NSAttributedString?
    private var prefferedStyle: UIAlertController.Style = .alert
    private var actions: [UIAlertAction] = [UIAlertAction(title: "ОК", style: .default, handler: nil)]
    private var defaultActions = true
    
    var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    func title(_ title: String?) -> AlertBuilder {
        self.title = title
        return self
    }
    
    func message(_ message: String?) -> AlertBuilder {
        self.message = message
        return self
    }
    
    func attributedMessage(_ message: NSAttributedString?) -> AlertBuilder {
        self.attributedMessage = message
        return self
    }
    
    func style(_ style: UIAlertController.Style) -> AlertBuilder {
        self.prefferedStyle = style
        return self
    }
    
    func actionCancel(handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        return action(title: "Скасувати", style: .cancel, handler: handler)
    }
    
    func actionYes(handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        return action(title: "Так", handler: handler)
    }
    
    func actionNo(handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        return action(title: "Ні", handler: handler)
    }
    
    func actionOk(handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        return action(title: "ОК", handler: handler)
    }
    
    func action(title: String, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        if defaultActions {
            actions = []
            defaultActions = false
        }
        self.actions.append(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: prefferedStyle)
        if let attributedMessage = attributedMessage {
            alert.setValue(attributedMessage, forKey: UIAlertControllerKeys.attributedMessage.rawValue)
        }
        
        for action in self.actions {
            alert.addAction(action)
        }
        return alert
    }
    
    func present() {
        guard let vc = vc else { return }
        vc.present(build(), animated: true, completion: nil)
    }
    
}
