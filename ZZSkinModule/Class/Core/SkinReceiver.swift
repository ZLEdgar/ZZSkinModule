//
//  SkinReceiver.swift
//  ZZSkinModule
//
//  Created by 罗静 on 2019/10/15.
//  Copyright © 2019 罗静. All rights reserved.
//

import Foundation

class SkinReceiver {
    static let sharedReceiver = SkinReceiver()
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(skinChange(notification:)), name: Notification.Name(rawValue: kSkinChangeKey), object: nil)
    }
    
    var receiveContainer = [SkinBridge]()
    
    @objc func skinChange(notification : Notification) {
        let skin = notification.object as! BaseSkin
        for tempSkinBridge in receiveContainer {
            tempSkinBridge.next(tempSkinBridge.sender,skin)
        }
    }
    
    public func subscribe(sender : AnyObject, identifer : String, next : @escaping (AnyObject,BaseSkin) -> Void) -> SkinBridge{
        guard let tempBridge = exsitBridge(for: identifer) else {
            let skinBridge = SkinBridge(sender: sender, identifer: identifer, next: next)
            receiveContainer.append(skinBridge)
            return skinBridge
        }
        return tempBridge
    }
    
    func exsitBridge(for identifer : String) -> SkinBridge? {
        for tempBridge in receiveContainer {
            if tempBridge.identifer == identifer {
                return tempBridge
            }
        }
        return nil
    }
}


public class SkinBridge {
    let sender : AnyObject
    let identifer : String
    let next : (AnyObject, BaseSkin) ->  Void
        
    init(sender : AnyObject, identifer : String , next : @escaping (AnyObject,BaseSkin) -> Void) {
        self.sender = sender;
        self.identifer = identifer
        self.next = next
    }
    
    public func execute() {
        self.next(self.sender,SkinManager.sharedManager.currentSkin!)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

public extension NSObject {
    
    func subscribe(next : @escaping (AnyObject,BaseSkin) -> Void) -> SkinBridge {
        return SkinReceiver.sharedReceiver.subscribe(sender: self, identifer: self.collectIdentifer(), next: next)
    }
    
    func collectIdentifer() -> String {
        let callStackSymbols = Thread.callStackReturnAddresses
        if callStackSymbols.count > 4 {
            let identifer = String(describing: self) + callStackSymbols[2].stringValue + callStackSymbols[3].stringValue
            return identifer
        }
        return String(describing: self)
    }
    
}
