//
//  SceneDelegate.swift
//  VimeoSProject001
//
//  Created by Willy Hsu on 2025/11/2.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .dark
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let root = window?.rootViewController else { return }
        if TokenKeychain.readToken() == nil {
            DispatchQueue.main.async { [weak self] in
                self?.presentTokenPrompt(on: root)
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// MARK: - Token Prompt & Validation
extension SceneDelegate {
    private func presentTokenPrompt(on presenter: UIViewController) {
        let ac = UIAlertController(title: "輸入 Vimeo Token",
                                   message: "貼上你的 Personal Access Token（只會儲存在此裝置）。",
                                   preferredStyle: .alert)
        ac.addTextField { tf in
            tf.placeholder = "Personal Access Token"
            tf.isSecureTextEntry = true
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
            tf.clearButtonMode = .whileEditing
        }
        ac.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "儲存並驗證", style: .default, handler: { [weak self, weak ac] _ in
            let token = ac?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !token.isEmpty else { return }
            self?.validatePAT(token) { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        _ = TokenKeychain.saveToken(token)
                    } else {
                        let err = UIAlertController(title: "Token 無效",
                                                    message: "請確認 PAT 是否正確與具備必要 scopes。",
                                                    preferredStyle: .alert)
                        err.addAction(UIAlertAction(title: "重新輸入", style: .default, handler: { [weak self] _ in
                            self?.presentTokenPrompt(on: presenter)
                        }))
                        presenter.present(err, animated: true)
                    }
                }
            }
        }))
        presenter.present(ac, animated: true)
    }

    private func validatePAT(_ token: String, completion: @escaping (Bool) -> Void) {
        var req = URLRequest(url: URL(string: "https://api.vimeo.com/me")!)
        req.httpMethod = "GET"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: req) { _, resp, _ in
            let code = (resp as? HTTPURLResponse)?.statusCode ?? -1
            completion((200..<300).contains(code))
        }.resume()
    }
}

