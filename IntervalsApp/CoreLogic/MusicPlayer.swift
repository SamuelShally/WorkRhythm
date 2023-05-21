//
//  MusicPlayer.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 7/9/21.
//

import SwiftUI
import AVFoundation
import MediaPlayer
import NotificationCenter

class MusicPlayer : ObservableObject
{
    var player = AVAudioPlayer()
    @Published var paused = true
    @State var nowPlaying = ""
   
    init()
    {
        do
        {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch
        {
                
        }
        
        let sound = Bundle.main.path(forResource: "rain", ofType: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        
        setUpCommandCenter()
        setupNowPlaying()
        
    }
    
    func playRainSounds()
    {
    
        player.stop()
        let sound = Bundle.main.path(forResource: "rain", ofType: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        player.numberOfLoops = -1
        player.play()
        

        self.paused = false
    }
    
    func playAirplaneSounds()
    {
       
        player.stop()
        let sound = Bundle.main.path(forResource: "jet", ofType: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        player.numberOfLoops = -1
        player.play()
        
        
        self.paused = false
        
    }
    
    func playCafeSounds()
    {
        
        player.stop()
        let sound = Bundle.main.path(forResource: "cafe", ofType: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        player.numberOfLoops = -1
        player.play()
        
        
        self.paused = false
        
    }
    
    func playOfficeSounds()
    {
        
        player.stop()
        let sound = Bundle.main.path(forResource: "office", ofType: "mp3")
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        player.numberOfLoops = -1
        player.play()
        
        
        self.paused = false
        
    }
    
    func setUpCommandCenter()
    {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget
        {
            [unowned self] event in
            
 
                player.play()

                self.paused = false

                return .success
        
        }
        
        commandCenter.pauseCommand.addTarget
        {
            [unowned self] event in
            
            player.pause()
            self.paused = true
            
            return .success
   
        }
        
    }
    
    func setupNowPlaying()
    {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Work Rhythm"
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
        
}
