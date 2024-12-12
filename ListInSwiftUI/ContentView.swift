import SwiftUI

struct ContentView: View {
    @State private var selectedPage = 0
    @State private var searchText = ""
    @State private var showBottomSheet = false
    
    private let carouselImages = ["image1", "image2", "image3"] // Replace with real image names or URLs
    private let listData = [
        ["apple", "banana", "cherry", "date"],
        ["orange", "kiwi", "mango", "papaya"],
        ["strawberry", "blueberry", "raspberry", "grape"]
    ]
    
    var filteredList: [String] {
        let currentList = listData[selectedPage]
        return searchText.isEmpty ? currentList : currentList.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(carouselImages.indices, id: \ .self) { index in
                    Image(carouselImages[index]) // Replace with your image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .padding(.horizontal, 10)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)
            .padding(.top, 30)
            
            HStack(spacing: 8) {
                ForEach(0..<carouselImages.count, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(index == selectedPage ? .blue : .gray)
                }
            }.padding(.top, 5)
    
            TextField("Search", text: $searchText)
                .padding(10) // Adjust padding as needed
                .background(Color(.systemBackground)) // To match the default RoundedBorderTextFieldStyle
                .cornerRadius(8) // To create rounded corners
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1) // Customize the border color and width
                )
                .padding(.horizontal, 20)
                .padding(.top, 5)
            
            List(filteredList, id: \ .self) { item in
                Text(item.capitalized)
            }
            .listStyle(.plain)
            .padding(.top, 20)
            .padding(.horizontal, 5)
            Spacer()
        }
        .overlay(
            FloatingActionButton(action: {
                showBottomSheet.toggle()
            }),
            alignment: .bottomTrailing
        )
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView(currentList: listData[selectedPage]).presentationDetents([.medium])
        }
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24))
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .padding()
    }
}

struct BottomSheetView: View {
    let currentList: [String]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Statistics")
                .font(.headline)
            Text("Total items: \(currentList.count)")
            let characterCounts = currentList.flatMap { $0.lowercased() }.reduce(into: [:]) { counts, char in
                counts[char, default: 0] += 1
            }
            let topCharacters = characterCounts.sorted(by: { $0.value > $1.value }).prefix(3)
            ForEach(topCharacters, id: \ .key) { key, value in
                Text("\(key) = \(value)")
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
