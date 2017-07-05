//
//  Utility.swift
//  SwipeSpeak
//
//  Created by Xiaoyi Zhang on 7/5/17.
//  Copyright © 2017 TeamGleason. All rights reserved.
//

import Foundation
import UIKit

// Constants
let addedWordFreq = 9999999
let buttonBackgroundColor = UIColor.init(white: 67/255, alpha: 1)
let buttonGreenColor = UIColor.init(red: 61/255, green: 193/255, blue: 71/255, alpha: 1)
let userAddedWordListName = "UserAddedWordList.csv"
let buildWordButtonText = "Build Word"
let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height
let numPredictionLabels = 8
let keyLetterGrouping4Keys = ["abcdef", "ghijkl", "mnopqrs", "tuvwxyz"]
let keyLetterGrouping6Keys = ["abcd", "efgh", "ijkl", "mnop", "qrstu", "vwxyz"]
let keyLetterGrouping8Keys = ["abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
let audioCue4Keys = ["Up", "Left", "Right", "Down"]
let audioCue6Keys = ["Up Left", "Up", "Up Right", "Left", "Right", "Down"]
let audioCue8Keys = ["Up Left", "Up", "Up Right", "Left", "Right", "Down Left", "Down", "Down Right"]


// Global
var userAddedWordListUpdated = false
var keyboardSettingsUpdated = false


func getNumberOfKeys() -> Int {
    if UserDefaults.standard.integer(forKey: "keyboard") <= 0 {
        setKeyboardNumber(4)
        return 4
    }
    return UserDefaults.standard.integer(forKey: "keyboard")
}

func setKeyboardNumber(_ keyboard: Int) {
    UserDefaults.standard.set(keyboard, forKey: "keyboard")
}

func fileInDocumentsDirectory(_ folderName: String, fileName: String) -> String {
    var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    if folderName != "" {
        url = url.appendingPathComponent(folderName)
    }
    url = url.appendingPathComponent(fileName)
    return url.path
}

func addWordToCSV(_ word: String) {
    let line = word + "," + String(addedWordFreq) + "\n"
    let data = line.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    let wordList = fileInDocumentsDirectory("", fileName: userAddedWordListName)
    if FileManager.default.fileExists(atPath: wordList) {
        if let fileHandle = FileHandle(forWritingAtPath: wordList) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            fileHandle.closeFile()
        }
    }
}

func getWordAndFrequencyListFromCSV(_ filepath: String) -> [(String, Int)]? {
    let contents = try? String(contentsOfFile: filepath)
    let lines = contents?.components(separatedBy: CharacterSet.newlines).filter{!$0.isEmpty}
    var wordAndFrequencyList = [(String, Int)]()
    for line in lines! {
        let pair = line.components(separatedBy: ",")
        if let frequency = Int(pair[1]) {
            wordAndFrequencyList.append((pair[0].lowercased(), frequency))
        } else {
            wordAndFrequencyList.append((pair[0].lowercased(), addedWordFreq))
        }
    }
    return wordAndFrequencyList
}