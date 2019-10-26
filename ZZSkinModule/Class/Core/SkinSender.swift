//
//  SkinSender.swift
//  ZZSkinModule
//
//  Created by 罗静 on 2019/10/15.
//  Copyright © 2019 罗静. All rights reserved.
//

import Foundation

let kSkinChangeKey = "skin_change_key"

public class SkinSender {
    public static func send(skinName : String) {
        guard SkinManager.sharedManager.currentSkin(equel: skinName) else {
            SkinManager.sharedManager.set(currentSkin: skinName)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kSkinChangeKey), object: SkinManager.sharedManager.currentSkin, userInfo: nil)
            return
        }
    }
}
