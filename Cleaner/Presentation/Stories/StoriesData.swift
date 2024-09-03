//
//  StoriesData.swift
//  Cleaner
//
//  Created by Максим Лебедев on 04.10.2023.
//

import UIKit

class StoriesData {
    
    static let shared = StoriesData()
    var telegram: [OnboardingModel] = []
    var whatsApp: [OnboardingModel] = []
    var viber: [OnboardingModel] = []
    var safari: [OnboardingModel] = []
    var offload: [OnboardingModel] = []
    var delete: [OnboardingModel] = []
    var batteryTutorialData: [OnboardingModel] = []
    var adblock: [OnboardingModel] = []
    
    func setup() {
        telegram = [
            OnboardingModel(
                text: self.customBolder(
                    text: "Open Settings",
                    boldWordsInd: []
                ),
                image: Asset.deviceclean.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Go to Safari",
                    boldWordsInd: []
                ),
                image: Asset.device27clean.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Tap Clear History and Website Data",
                    boldWordsInd: []
                ),
                image: Asset.device28clean.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Confirm your action",
                    boldWordsInd: []
                ),
                image: Asset.device29clean.image)
        ]
        
        whatsApp = [
            OnboardingModel(
                text: self.customBolder(
                    text: "Open Telegram",
                    boldWordsInd: []
                ),
                image: Asset.devicetel.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Go to Settings > Data and Storage",
                    boldWordsInd: []
                ),
                image: Asset.device1tel.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Tap Storage Usage",
                    boldWordsInd: []
                ),
                image: Asset.devicetel1.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Choose Clear Entire Cashe",
                    boldWordsInd: []
                ),
                image: Asset.device3tel.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Select items to remove and Tap Clear",
                    boldWordsInd: []
                ),
                image: Asset.device4tel.image)
        ]
        
        viber = [
            OnboardingModel(
                text: self.customBolder(
                    text: "Open Settings",
                    boldWordsInd: []
                ),
                image: Asset.deviceoff.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Go to General",
                    boldWordsInd: []
                ),
                image: Asset.device2off.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Tap IPhone Storage",
                    boldWordsInd: []
                ),
                image: Asset.device13off.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Enabled Offload Unused Apps",
                    boldWordsInd: []
                ),
                image: Asset.device14off.image)
        ]
        
        safari = [
            OnboardingModel(
                text: self.customBolder(
                    text: "Open Viber",
                    boldWordsInd: []
                ),
                image: Asset.deviceoptimize.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Go to More > Settings",
                    boldWordsInd: []
                ),
                image: Asset.deviceoptimize1.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Choose Media",
                    boldWordsInd: []
                ),
                image: Asset.device11optimize.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Tap Keep Media",
                    boldWordsInd: []
                ),
                image: Asset.device12optimize.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Select Time Period",
                    boldWordsInd: []
                ),
                image: Asset.device3optimize.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Confirm your selection",
                    boldWordsInd: []
                ),
                image: Asset.device9optimize.image)
        ]
        
        offload = [
            OnboardingModel(
                text: self.customBolder(
                    text: "Open WhatsApp",
                    boldWordsInd: [1, 2]
                ),
                image: Asset.deviceclean.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Go to Settings > Storage and Data",
                    boldWordsInd: [0, 1, 2, 3, 4, 5, 6]
                ),
                image: Asset.device4whats.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Tap Manage Storage",
                    boldWordsInd: [0, 1, 2]
                ),
                image: Asset.device5whats.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Open Chat",
                    boldWordsInd: [0, 1]
                ),
                image: Asset.device6whats.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Select items to remove",
                    boldWordsInd: [0, 1, 2, 3]
                ),
                image: Asset.device7whats.image),
            OnboardingModel(
                text: self.customBolder(
                    text: "Confirm your action",
                    boldWordsInd: []
                ),
                image: Asset.device7whats.image)
        ]
    }
    
    private func customBolder(text: String, boldWordsInd: [Int]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let words = text.components(separatedBy: " ")
        
        for wordIndex in boldWordsInd {
            if wordIndex < words.count {
                let word = words[wordIndex]
                let wordRange = (text as NSString).range(of: word)
                attributedText.addAttribute(.font, value: FontFamily.SFProDisplay.bold.font(size: 14) ?? UIFont.boldSystemFont(ofSize: 14), range: wordRange)
            }
        }
        
        return attributedText
    }
}
