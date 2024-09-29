//
//  AddListItemView.swift
//  FitPlus
//
//  Created by Kaue de Assis Jacyntho on 21/07/24.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var listViewModel = GrocerShopListViewModel()
    @State var textFieldText: String = ""
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    @State var listId: String = ""

    init(listId: String) {
        self.listId = listId
        print("kauekaj \(listId)")
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Informe aqui...", text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                Button {
                    saveButtonPressed()
                } label: {
                    Text("Adicionar".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }

            }
            .padding(14)
        }
        .navigationTitle("Adicione um item 🖋")
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
//            listViewModel.addItem(title: textFieldText)
            Task {
                try await ListsManager.shared.addItem(listId: listId, name: "kaue2")
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textFieldText.count < 3 {
            alertTitle = "Your new todo item must be at least 3 characters long!!!😰😩😓"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddView(listId: "")
        }
//        .environmentObject(GrocerShopListViewModel())
    }
}
