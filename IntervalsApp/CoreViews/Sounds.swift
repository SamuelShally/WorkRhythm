//
//  Sounds.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 7/8/21.
//

import SwiftUI
import AVFoundation
import MediaPlayer
import NotificationCenter

struct Sounds: View
{
    //Enviroment Objects
    @EnvironmentObject var indexes : Indexes
    @EnvironmentObject var music : MusicPlayer
    
    var body: some View
    {
        NavigationView
        {
            GeometryReader
            {
                geometry in

                VStack(spacing: 10)
                {
                    Spacer()
                    
                    HStack(spacing: 10)
                    {
                        Button(action :
                        {music.playRainSounds()})
                        {
                            Image(systemName: "cloud.rain").font(.system(size: 30, weight: .bold)).foregroundColor(Color(red: 0.29, green: 0.25, blue: 0.88))
                                .frame(width: 100, height : 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                         .fill(Color.gray)
                                         .opacity(0.75)
                                 )
                            
                        }

                        
                        Button(action : {music.playAirplaneSounds()})
                        {
                            Image(systemName: "airplane").font(.system(size: 30, weight: .bold)).foregroundColor(Color(red: 0.29, green: 0.25, blue: 0.88))
                                .frame(width: 100, height : 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                         .fill(Color.gray)
                                         .opacity(0.75)
                                 )
                            
                        }

                    }
                    HStack(spacing: 10)
                    {
                        Button(action : {music.playCafeSounds()})
                        {
                            Image(systemName: "person.3").font(.system(size: 30, weight: .bold)).foregroundColor(Color(red: 0.29, green: 0.25, blue: 0.88))
                                .frame(width: 100, height : 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                         .fill(Color.gray)
                                         .opacity(0.75)
                                 )
                        }

                        
                        Button(action : {music.playOfficeSounds()})
                        {
                            Image(systemName: "building.2").font(.system(size: 30, weight: .bold)).foregroundColor(Color(red: 0.29, green: 0.25, blue: 0.88))
                                .frame(width: 100, height : 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                         .fill(Color.gray)
                                         .opacity(0.75)
                                 )
                            
                        }

                        
                    }
                    
                    Spacer()
                    
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                             .fill(Color.orange)
                             .opacity(0.8)
                             .frame(width: geometry.size.width*0.9, height: 50)
                             
                    
                        Button(action:
                        {
                            if(music.paused == true)
                            {
                                music.player.play()
                                music.paused = false
                                
                            }
                            else
                            {
                                music.player.pause()
                                music.paused = true
                                
                            }
                            
                        })
                        {
                        
                            Image( systemName: music.paused == true ?  "play" :  "pause")
                                .font(.system(size: 30, weight: .bold)).foregroundColor(Color(red: 0.29, green: 0.25, blue: 0.88))
                                .frame(width: geometry.size.width)
                                
                                    
                                 
                        }
                    
                        
                        
                    }
                    

                }
                .padding(.bottom)
               
                .frame(width: geometry.size.width, height: geometry.size.height)
       
                .navigationBarTitle("Sounds",  displayMode: .large)
                
                .background(
                        Image("\(indexes.background)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .blur(radius: 6)
                )

            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
 
    }
 
}


struct Sounds_Previews: PreviewProvider
{
    static var previews: some View
    {
        Sounds()
            .environmentObject(Indexes())
            .environmentObject(MusicPlayer())
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
