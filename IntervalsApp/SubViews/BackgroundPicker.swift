//
//  BackgroundPicker.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 7/9/21.
//

import SwiftUI

struct BackgroundPicker: View
{
    @EnvironmentObject var indexes : Indexes
    
    @Binding var backgroundSheet : Bool
    
    @EnvironmentObject var music : MusicPlayer
    
    
    @State var backgroundOne = false
    @State var backgroundTwo = false
    @State var backgroundThree = false
    @State var backgroundFour = false
    @State var backgroundFive = false
    @State var backgroundSix = false
    
    
    var body: some View
    {
        NavigationView
        {
            ScrollView
            {
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20)
                {
                    HStack
                    {
                        Button(action:
                        {
//                            music.player.stop()
                            
                            self.backgroundOne = true
                            self.backgroundTwo = false
                            self.backgroundThree = false
                            self.backgroundFour = false
                            self.backgroundFive = false
                            self.backgroundSix = false
                            
                            NewData.cloudDefaults.set("backgroundOne", forKey:"background")
                            
                            indexes.background = NewData.cloudDefaults.string(forKey: "background")!
                            
                            NewData.cloudDefaults.synchronize()

                        })
                        {
                            Image("backgroundOne")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .border(self.backgroundOne ? Color.blue : Color.black,width: 5)
                                
                        }.padding()
                        
                        Button(action:
                        {
                            self.backgroundOne = false
                            self.backgroundTwo = true
                            self.backgroundThree = false
                            self.backgroundFour = false
                            self.backgroundFive = false
                            self.backgroundSix = false
                            
                            NewData.cloudDefaults.set("backgroundTwo", forKey:"background")

                            indexes.background = NewData.cloudDefaults.string(forKey: "background")!

                            NewData.cloudDefaults.synchronize()
                            
                        })
                        {
                            Image("backgroundTwo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .border(self.backgroundTwo ? Color.blue : Color.black,width: 5)
                            
                        }.padding()
                        
                    }
                    
                    HStack
                    {
                        Button(action:
                        {
                            self.backgroundOne = false
                            self.backgroundTwo = false
                            self.backgroundThree = true
                            self.backgroundFour = false
                            self.backgroundFive = false
                            self.backgroundSix = false
                            
                            NewData.cloudDefaults.set("backgroundThree", forKey:"background")
                            
                            indexes.background = NewData.cloudDefaults.string(forKey: "background")!
                            
                            NewData.cloudDefaults.synchronize()
                            
                        })
                        {
                            Image("backgroundThree")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .border(self.backgroundThree ? Color.blue : Color.black,width: 5)

                                
                        }.padding()
                        
                        Button(action:
                        {
                            self.backgroundOne = false
                            self.backgroundTwo = false
                            self.backgroundThree = false
                            self.backgroundFour = true
                            self.backgroundFive = false
                            self.backgroundSix = false
                            
                            NewData.cloudDefaults.set("backgroundFour", forKey:"background")
                            
                            indexes.background = NewData.cloudDefaults.string(forKey: "background")!
                            
                            NewData.cloudDefaults.synchronize()
                            
                        })
                        {
                            Image("backgroundFour")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .border(self.backgroundFour ? Color.blue : Color.black,width: 5)
                            
                        }.padding()
                        
                    }
                    
                    HStack
                    {
                        Button(action:
                        {
                            self.backgroundOne = false
                            self.backgroundTwo = false
                            self.backgroundThree = false
                            self.backgroundFour = false
                            self.backgroundFive = true
                            self.backgroundSix = false
                            
                            NewData.cloudDefaults.set("backgroundFive", forKey:"background")
                            
                            indexes.background = NewData.cloudDefaults.string(forKey: "background")!
                            
                            NewData.cloudDefaults.synchronize()
                            
                        })
                        {
                            Image("backgroundFive")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .border(self.backgroundFive ? Color.blue : Color.black,width: 5)
                                
                        }.padding()
                        
                        Button(action:
                        {
                            self.backgroundOne = false
                            self.backgroundTwo = false
                            self.backgroundThree = false
                            self.backgroundFour = false
                            self.backgroundFive = false
                            self.backgroundSix = true
                            
                            NewData.cloudDefaults.set("backgroundSix", forKey:"background")
                            
                            indexes.background = NewData.cloudDefaults.string(forKey: "background")!
                            
                            NewData.cloudDefaults.synchronize()
                        })
                        {
                            Image("backgroundSix")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .border(self.backgroundSix ? Color.blue : Color.black,width: 5)
                            
                        }.padding()
                        
                    }
                    
                }
                .onAppear()
                {
                    selection()
                }
            }
            .navigationBarTitle(Text("Backgrounds"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {self.backgroundSheet = false}) {Text("Dismiss")})
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func selection() -> Void
    {
        let current = ["backgroundOne","backgroundTwo","backgroundThree","backgroundFour","backgroundFive","backgroundSix"]
     
        var count = 1
        
        for x in current
        {
            let current = NewData.cloudDefaults.string(forKey: "background")
            
            if(x == current)
            {
                switch count
                {
                    case 1 :
                        self.backgroundOne = true
                    case 2 :
                        self.backgroundTwo = true
                    case 3 :
                        self.backgroundThree = true
                    case 4:
                        self.backgroundFour = true
                    case 5:
                        self.backgroundFive = true
                    case 6:
                        self.backgroundSix = true
                    default:
                        break

                }
                
                break
  
            }
            
            count += 1
        }
        
    }
}

//struct BackgroundPicker_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//
//        BackgroundPicker().environmentObject(Indexes())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
//
//        
//        ViewOne()
//            .environmentObject(Indexes())
//                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//            
//        BackgroundPicker().environmentObject(Indexes())
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (3rd generation)"))
//        
//        ViewOne()
//            .environmentObject(Indexes())
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation)"))
//    }
//}
