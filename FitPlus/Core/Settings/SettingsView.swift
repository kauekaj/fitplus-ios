//
//  SettingsView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 08/10/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var accountRows: [RowData] = [
        RowData(icon: "lock", text: "Mudar senha", destination: AnyView(Text("Mudar Senha"))),
        RowData(icon: "trash", text: "Delete Account", destination: AnyView(Text("Delete Account View")))
    ]
   
    @State private var aboutRows: [RowData] = [
        RowData(icon: "doc.text", text: "Temos e Condições", destination: AnyView(Text("Temos e Condições"))),
        RowData(icon: "shield.checkerboard", text: "Política de Privacidade", destination: AnyView(Text("Política de Privacidade"))),
    ]
    
    @State private var generalRows: [RowData] = [
        RowData(icon: "", text: "Versão do aplicativo: \(Bundle.main.appVersion)", destination: nil)
    ]
    
    var body: some View {
        VStack {
            List {
                Section("Conta") {
                    ForEach(accountRows) { rowData in
                        NavigationLink(destination: rowData.destination) {
                            RowComponent(verticalPadding: 1, horizontalPadding: 0, icon: true, rowData: rowData)
                        }
                    }
                    .padding(0)
                }
                .listRowSeparator(.visible)
                .padding(0)
                

                Section("Sobre") {
                    ForEach(aboutRows) { rowData in
                        NavigationLink(destination: rowData.destination) {
                            RowComponent(verticalPadding: 1, horizontalPadding: 0, icon: true, rowData: rowData)
//                                .background(.red)
                        }
                    }
                    .padding(0)
                }
                .listRowSeparator(.visible)
                .padding(0)
                
                Section("Geral") {
                    ForEach(generalRows) { rowData in
                        RowComponent(verticalPadding: 1, horizontalPadding: 1, font: .footnote, rowData: rowData)
                    }
                }
                .padding(0)
            }
            .navigationTitle("Settings")
        }
    }
}
