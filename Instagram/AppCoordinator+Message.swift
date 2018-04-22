//
//  AppCoordinator+Message.swift
//  Instagram
//
//  Created by Kaushal on 08/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import UIKit

extension AppCoordinator: ConversationControllerDelegate {
    func conversationsController(_ controller: UIViewController, didSelectConversation conversationId: String) {
        let messagePage = MessageController(conversationid: conversationId)
        messagePage.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(messagePage, animated: true)
    }
}
