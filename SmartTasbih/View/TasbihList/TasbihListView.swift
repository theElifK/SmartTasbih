import SwiftUI

struct TasbihListView: View {
    @StateObject private var vm = TasbihListViewModel()
    @State private var selectedTasbih: TasbihDataModel?
    @State private var navigateToDetail = false
    
    var body: some View {
        VStack{
            NavigationView {
                List(vm.items) { item in
                    
                    CustomCellView(
                        tasbih: item,
                        onDelete: {  vm.deleteItem(item) },
                        onSelect: { openDetail(item) }
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                
                //view ilk açıldığında, bir sayfadan geri dönüldüğünde, yeniden visible olduğunda çalışır
                .onAppear { vm.fetchItems() }
                
                .background(
                    NavigationLink(
                        destination: selectedTasbih.map { tasbih in
                            TasbihDetailView(tasbih: tasbih)
                        },
                        isActive: $navigateToDetail
                    ) {
                        EmptyView()
                    }
                        .hidden()
                    
                )
            }
        }
     
    }
    
    private func openDetail(_ item: TasbihDataModel) {
        selectedTasbih = item
        navigateToDetail = true
    }
}

#Preview {
    TasbihListView()
}

