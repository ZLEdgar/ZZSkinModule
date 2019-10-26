//
//  SkinManager.swift
//  ZZSkinModule
//
//  Created by 罗静 on 2019/10/15.
//  Copyright © 2019 罗静. All rights reserved.
//

import Foundation

let kSkinName = "kSkinName"

public class SkinManager {
    public static let sharedManager = SkinManager()
    private init(){}
    
    var skins = [String : BaseSkin]()
    
    var skin : BaseSkin? {
        didSet {
            let skinName = String(describing: object_getClass(skin)!)
            var oldSkinName : String?
            if oldValue != nil {
               oldSkinName = String(describing: object_getClass(oldValue)!)
            }
            guard let tempOldName = oldSkinName, tempOldName == skinName else {
                UserDefaults.standard.set(skinName, forKey: kSkinName)
                return
            }
        }
    }
    
    public var currentSkin : BaseSkin? {
        return skin
    }
    
    func addSkin<skin : BaseSkin>(skin : skin) {
        let skinName = String(describing: object_getClass(skin)!)
        skins[skinName] = skin
        
        self.skin = skin
    }
    
    public static func registerSkins(){
        let blackSkin = BlackSkin()
        SkinManager.sharedManager.addSkin(skin: blackSkin)
        
        let whiteSkin = WihteSkin()
        SkinManager.sharedManager.addSkin(skin: whiteSkin)
        
        if let skinName = UserDefaults.standard.string(forKey: kSkinName) {
            if skinName == "BlackSkin" {
                SkinManager.sharedManager.skin = blackSkin
            }else {
                SkinManager.sharedManager.skin = whiteSkin
            }
        }
    }
    
    
    func set(currentSkin skinName : String) {
        let skin = skins[skinName]
        self.skin = skin
    }
    
    func currentSkin(equel skinName : String) -> Bool {
        guard let tempSkin = self.skin else {
            return false
        }
        
        guard let skin = skins[skinName],tempSkin === skin else {
            return false
        }
        
        return true
    }
}
