////
////  CookBookView.swift
////  Save-A-Recipe
////
////  Created by Henrik Sjögren on 2022-02-14.
////
//
//import SwiftUI
//
//struct CookBookView: View {
//    
//    @State var shouldShowLogOutOptions = false
//    
//    var body: some View {
//        
//        NavigationView {
//            VStack {
//                HStack(spacing: 16) {
//                    
//                    Image(systemName: "person.fill")
//                        .font(.system(size: 34, weight: .heavy))
//                    
//                    VStack (alignment: .leading, spacing: 4) {
//                        Text("USER NAME")
//                            .font(.system(size: 24, weight: .bold))
//                        HStack {
//                            Circle()
//                                .foregroundColor(.green)
//                                .frame(width: 14, height: 14)
//                            Text("online")
//                                .font(.system(size: 12))
//                                .foregroundColor(Color(.lightGray))
//                        }
//                    }
//                    
//                    Spacer()
//                    Button {
//                        shouldShowLogOutOptions.toggle()
//                    } label: {
//                        Image(systemName: "gear")
//                            .font(.system(size: 24, weight: .bold))
//                            .foregroundColor(Color(.label))
//                    }
//                }
//                .padding()
//                .actionSheet(isPresented: $shouldShowLogOutOptions) {
//                    .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
//                        .destructive(Text("Sign Out"), action: {
//                            print("handle sign out")
//                        }),
//                        .cancel()
//                    ])
//                }
//                
//                
//                
//                ScrollView {
//                    ForEach(0..<10, id: \.self) { num in
//                        VStack {
//                            HStack(spacing: 16) {
//                                Image(systemName: "person.fill")
//                                    .font(.system(size: 32))
//                                    .padding()
//                                    .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black, lineWidth: 1))
//                                
//                                
//                                VStack(alignment: .leading) {
//                                    Text("Username")
//                                        .font(.system(size: 16, weight: .bold))
//                                    Text("Message sent ot user")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Color(.lightGray))
//                                }
//                                Spacer()
//                                Text("22d")
//                                    .font(.system(size: 14, weight: .semibold))
//                            }
//                            Divider()
//                                .padding(.vertical, 8)
//                        }.padding(.horizontal)
//                    }.padding(.bottom, 50)
//                    
//                    
//                }
//                
//                
//            }
//            .overlay(Button {
//                
//            } label: {
//                HStack {
//                    Spacer()
//                    Text("+ New Message")
//                        .font(.system(size: 15, weight: .bold))
//                    Spacer()
//                }
//                .foregroundColor(.white)
//                .padding(.vertical)
//                .background(Color.blue)
//                .cornerRadius(32)
//                .padding(.horizontal)
//            }, alignment: .bottom)
//            .navigationBarHidden(true)
//            
//            //   .navigationTitle("CookBook")
//        }
//    }
//}
//
//struct CookBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        CookBookView()
//    }
//}
//
//
///*
// HStack {
// Text("User profile uid")
// VStack {
// Text("Username")
// Text("Message")
// }
// Spacer()
// Text("22d")
// .font(.system(size: 14, weight: .semibold))
// }
// Divider()
// */
