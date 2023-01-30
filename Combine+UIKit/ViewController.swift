//
//  ViewController.swift
//  Combine+UIKit
//
//  Created by Matthew Dolan on 2023-01-28.
//

import UIKit
import Combine

// Setup notification centre based publisher
extension Notification.Name {
    static let newBlogPost = Notification.Name("newPost")
}

struct BlogPost {
    let title: String
}

class ViewController: UIViewController {
    
    @IBOutlet var blogTextField: UITextField!
    @IBOutlet var publishedButton: UIButton!
    @IBOutlet var subscribedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishedButton.addTarget(self, action: #selector(publishButtonTapped), for: .primaryActionTriggered)
        
        
        // Create a publisher
        let publisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
            .map { (notification) -> String? in
                return (notification.object as? BlogPost)?.title ?? ""
            }
        
        // Create a subscriber
        let subscriber = Subscribers.Assign(object: subscribedLabel, keyPath: \.text)
        publisher.subscribe(subscriber)
    }
    
    @objc func publishButtonTapped(_ sender: UIButton) {
        // Post the notification
        let title = blogTextField.text ?? "Coming soon"
        let blogPost = BlogPost(title: title)
        NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
    }
}
