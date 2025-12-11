//
//  AddTasbihView.swift
//  SmartTasbih
//
//  Created by Elif Karakolcu on 7.12.2025.
//

import SwiftUI

struct AddTasbihView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var vm: AddTasbihViewModel

    init(viewModel: AddTasbihViewModel = AddTasbihViewModel()) {
        _vm = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Başlık
                VStack(alignment: .leading, spacing: 6) {
                    Text("Yeni Tesbih Ekle")
                        .font(.title2)
                        .bold()
                    Text("Bir isim verin (ör. Sabah, Akşam, 99luk...).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // TextField
                TextField("Tesbih ismi", text: $vm.name)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .disableAutocorrection(true)

                VStack(alignment: .leading, spacing: 6) {
                 
                    Text("Varsa hedef sayı girin (ör. 99, 313, 4444...).")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // TextField
                TextField("Tesbih sayısı", text: $vm.target)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .disableAutocorrection(true)
                    .keyboardType(.numberPad)
                    .onChange(of: vm.target) { newValue in
                        // Rakam olmayan karakterleri temizle
                        vm.target = vm.target.filter { $0.isNumber }
                    }
                // Önizleme kartı
                HStack {
                    VStack(alignment: .leading) {
                        Text("Önizleme:")
                            .font(.system(size: 20,weight: .semibold))
                            .foregroundColor(.gray)
                        Text(vm.name.isEmpty ? "Tesbih İsmi" : vm.name)
                            .font(.system(size: 18,weight: .semibold))
                            .foregroundColor(.black)
                        HStack{
                            Text("0")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("/")
                                .font(.system(size:18))
                                .foregroundColor(.gray)
                            Text(vm.target.isEmpty ? "Hedef" : " \(vm.target)")
                                .font(.system(size:18))
                                .foregroundColor(.gray)
                            
                        }
                        HStack{
                            Text("Oluşturma: \(Date(), formatter: shortDateFormatter)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            
                            Image(systemName: "trash")
                                .padding()
                                .opacity(0.7)
                                .foregroundColor(.red)
                        }
                    }
                    
                   
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemGray6)))
                .animation(.default, value: vm.name)

                Spacer()

                // Kaydet butonu
                Button(action: {
                    vm.save { success in
                        if success {
                            vm.name = ""
                            vm.target = ""
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    HStack {
                        if vm.isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(.trailing, 6)
                        }
                        Text("Kaydet")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(vm.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isSaving)

            }
            .padding()
            .alert(isPresented: $vm.showAlert) {
                Alert(title: Text("Uyarı"), message: Text(vm.alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
    }

    private var shortDateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }
}

struct AddTasbihView_Previews: PreviewProvider {
    static var previews: some View {
        AddTasbihView(viewModel: AddTasbihViewModel(context: CoreDataManager.shared.context))
    }
}
