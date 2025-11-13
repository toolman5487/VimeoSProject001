//  AlertPresenter.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/10.
//

import UIKit

enum AlertPresenter {

    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let handler: (() -> Void)?

        init(title: String,
             style: UIAlertAction.Style = .default,
             handler: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }

        static func `default`(_ title: String,
                              handler: (() -> Void)? = nil) -> Action {
            Action(title: title, style: .default, handler: handler)
        }

        static func cancel(_ title: String = "Cancel",
                           handler: (() -> Void)? = nil) -> Action {
            Action(title: title, style: .cancel, handler: handler)
        }

        static func destructive(_ title: String,
                                handler: (() -> Void)? = nil) -> Action {
            Action(title: title, style: .destructive, handler: handler)
        }
    }

    struct TextFieldConfiguration {
        let placeholder: String?
        let text: String?
        let configurationHandler: ((UITextField) -> Void)?

        init(placeholder: String? = nil,
             text: String? = nil,
             configurationHandler: ((UITextField) -> Void)? = nil) {
            self.placeholder = placeholder
            self.text = text
            self.configurationHandler = configurationHandler
        }
    }

    static func present(from presenter: UIViewController,
                        title: String?,
                        message: String?,
                        preferredStyle: UIAlertController.Style = .alert,
                        tintColor: UIColor? = nil,
                        actions: [Action] = [.default("Comfirm")],
                        textFields: [TextFieldConfiguration] = [],
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
        guard !actions.isEmpty else {
            assertionFailure("AlertPresenter need Action")
            return
        }

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)

        textFields.forEach { configuration in
            alertController.addTextField { textField in
                textField.placeholder = configuration.placeholder
                textField.text = configuration.text
                configuration.configurationHandler?(textField)
            }
        }

        actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title,
                                            style: action.style) { _ in
                action.handler?()
            }
            alertController.addAction(alertAction)
        }

        if let tintColor {
            alertController.view.tintColor = tintColor
        }

        DispatchQueue.main.async {
            presenter.present(alertController, animated: animated, completion: completion)
        }
    }

    static func presentError(from presenter: UIViewController,
                             title: String = "Oops",
                             message: String,
                             actionTitle: String = "OK",
                             completion: (() -> Void)? = nil) {
        present(from: presenter,
                title: title,
                message: message,
                actions: [.default(actionTitle, handler: completion)])
    }
}
