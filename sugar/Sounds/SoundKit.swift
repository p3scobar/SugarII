//
//  SoundKit.swift
//  sugarDev
//
//  Created by Hackr on 12/9/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import AudioToolbox

struct SoundKit {
    
    enum SoundType: String {
        case tab
        case button = "tab02"
        case pay
        case select = "select01"
        case send = "tab01"
        case menuButton
    }
    
    static let shared = SoundKit()
    
    private var sounds = [SystemSoundID]()
    
    private init() {
        sounds = [
            self.soundID(for: .tab)
        ]
    }
    
    static func playSound(type: SoundType) {
        shared.playSound(type: type)
    }
    
    func soundID(for type: SoundType) -> SystemSoundID {
        var soundID: SystemSoundID = 0
        
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "m4a") else { return soundID }
        AudioServicesCreateSystemSoundID((url as NSURL), &soundID)
        
        return soundID
    }
    
    func playSound(type: SoundType) {
        guard UIApplication.shared.applicationState == .active else { return }
        
        let id = soundID(for: type)
        AudioServicesPlaySystemSound(id)
    }
}

