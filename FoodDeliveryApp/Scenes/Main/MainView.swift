import SwiftUI

// MARK: - Модели данных
struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let category: String
    let name: String
    let description: String
    let price: Int
    let imageName: String
}


struct PromoBanner: Identifiable {
    let id = UUID()
    let imageName: String
}

// MARK: - Данные
fileprivate let categories: [String] = ["Пицца", "Комбо", "Десерты", "Напитки", "Салаты", "Закуски"]

fileprivate let promoBanners: [PromoBanner] = [
    PromoBanner(imageName: "discount-30"),
    PromoBanner(imageName: "birthday-promo"),
]

fileprivate let menuItems: [MenuItem] = [
    MenuItem(category: "Пицца", name: "Ветчина и грибы", description: "Ветчина, шампиньоны, увеличенная порция моцареллы, томатный соус", price: 345, imageName: "Bufallo"),
    MenuItem(category: "Пицца", name: "Баварские колбаски", description: "Баварские колбаски,ветчина,пикантная пепперони,острая чоризо,моцарелла,томатный соус", price: 345, imageName: "Bayern"),
    MenuItem(category: "Пицца", name: "Нежный лосось", description: "Лосось, томаты черри, моцарелла, соус песто", price: 345, imageName: "Marino"),
    
    MenuItem(category: "Комбо", name: "Комбо 1", description: "Пицца, напиток и десерт", price: 599, imageName: "Combo-1"),
    MenuItem(category: "Комбо", name: "Комбо 2", description: "2 пиццы, 2 напитка", price: 899, imageName: "Combo-2"),
    
    MenuItem(category: "Десерты", name: "Чизкейк", description: "Классический чизкейк с вишнёвым топпингом", price: 250, imageName: "Сheesecake"),
    MenuItem(category: "Десерты", name: "Тирамису", description: "Классический итальянский десерт", price: 280, imageName: "Tiramisu"),
    
    MenuItem(category: "Напитки", name: "Кола", description: "Газированный напиток 0.5л", price: 100, imageName: "Cola"),
    MenuItem(category: "Напитки", name: "Сок", description: "Апельсиновый сок 1л", price: 150, imageName: "Juice")
]

fileprivate let menuDictionary = Dictionary(grouping: menuItems, by: { $0.category })

// MARK: - Главная View
struct MainView: View {
    @EnvironmentObject var appStateManager: AppStateManager

    @State private var showSuccessBanner: Bool = false
    @State private var selectedCategory: String? = "Пицца"
    @State private var selectedTab: Tab = .menu

    enum Tab: String {
        case menu, contacts, profile, cart
    }

    var body: some View {
        ZStack(alignment: .top) {
            NavigationView {
                ZStack(alignment: .bottom) {
                    Color.backgroundMain.ignoresSafeArea()

                    switch selectedTab {
                    case .menu:
                        MenuScreenContent(
                            showSuccessBanner: $showSuccessBanner,
                            appStateManager: appStateManager,
                            selectedCategory: $selectedCategory
                        )
                    case .contacts:
                        Text("Контакты")
                    case .profile:
                        ProfileView()
                    case .cart:
                        Text("Корзина")
                    }

                    CustomTabBarView(selectedTab: $selectedTab)
                }
                .navigationTitle(navigationTitleForTab)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                    Button(action: {
                        // Логика выбора города
                    }) {
                        HStack(spacing: 4) {
                            Text("Москва")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                        }
                    }
                )
                .navigationBarBackButtonHidden(true)
            }

            if showSuccessBanner, let message = appStateManager.mainScreenMessage {
                SuccessBannerView(message: message) {
                    showSuccessBanner = false
                    appStateManager.mainScreenMessage = nil
                }
                .transition(.move(edge: .top))
                .animation(.easeInOut, value: showSuccessBanner)
                .zIndex(1)
            }
        }
        .onAppear {
            if appStateManager.mainScreenMessage != nil {
                showSuccessBanner = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if showSuccessBanner {
                        showSuccessBanner = false
                        appStateManager.mainScreenMessage = nil
                    }
                }
            }
        }
    }

    private var navigationTitleForTab: String {
        switch selectedTab {
        case .menu: return ""
        case .contacts: return "Контакты"
        case .profile: return "Профиль"
        case .cart: return "Корзина"
        }
    }
}



// MARK: - Вспомогательные View

struct MenuScreenContent: View {
    @Binding var showSuccessBanner: Bool
    @ObservedObject var appStateManager: AppStateManager
    @Binding var selectedCategory: String?

    @State private var headerOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            
            
            VStack(spacing: 0) {
            
                MenuContentSection(selectedCategory: $selectedCategory)
                    .padding(.top, 24)
                    .padding(.bottom, 80)
            }
            .background(Color("backgroundMain"))
            
        
        }
    }
}


struct MenuContentSection: View {
    @Binding var selectedCategory: String?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    
                    PromotionsView()

                    Section(header:
                        CategoryBarView(
                            categories: categories,
                            selectedCategory: $selectedCategory
                        )
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                        .background(Color.backgroundMain)
                    ) {
                        ForEach(categories, id: \.self) { category in
                            if let items = menuDictionary[category] {
                                VStack (spacing: 1){
                                    ForEach(Array(items.enumerated()), id: \.1.id) { index, item in
                                        VStack(spacing: 0) {
                                            MenuItemView(
                                                item: item,
                                                isFirst: index == 0,
                                                isLast: index == items.count - 1
                                            )
                                            
                                            if index < items.count - 1 {
                                                Divider()
                                                    .frame(height: 1)
                                                    .background(Color.gray.opacity(0.2))
                                                    .padding(.horizontal, 0)
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .onChange(of: selectedCategory) { category in
                    if let category = category {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(category, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

struct PromotionsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(promoBanners) { banner in
                    Image(banner.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 112)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
    }
}


struct CategoryBarView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .font(.system(size: 13, weight: selectedCategory == category ? .bold : .regular))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 23)
                            .background(selectedCategory == category ? Color.activeCategoryText.opacity(0.2) : Color.clear)
                            .foregroundColor(selectedCategory == category ? .activeCategoryText : .activeCategoryText.opacity(0.4))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(selectedCategory == category ? Color.clear : Color.activeCategoryText.opacity(0.2))
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


struct MenuItemView: View {
    let item: MenuItem
    let isFirst: Bool
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 132, height: 132)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)

                    Text(item.description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(nil)

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            // Логика добавления в корзину
                        }) {
                            Text("от \(item.price) р")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.activeCategoryText)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.white)
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.activeCategoryText, lineWidth: 1)
                                )
                        }
                    }
                }
            }
            .padding(16)
            .frame(height: 160)
        }
        .background(Color.white)
        .clipShape(RoundedCornerShape(
            radius: 16,
            corners: cornersToRound
        ))
    }

    private var cornersToRound: UIRectCorner {
        if isFirst && isLast {
            return [.allCorners]
        } else if isFirst {
            return [.topLeft, .topRight]
        } else if isLast {
            return [.bottomLeft, .bottomRight]
        } else {
            return []
        }
    }
}

struct CustomTabBarView: View {
    @Binding var selectedTab: MainView.Tab

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                TabBarButton(systemIconName: "takeoutbag.and.cup.and.straw.fill", label: "Меню", isSelected: selectedTab == .menu) {
                    selectedTab = .menu
                }
                Spacer()
                TabBarButton(systemIconName: "mappin.and.ellipse", label: "Контакты", isSelected: selectedTab == .contacts) {
                    selectedTab = .contacts
                }
                Spacer()
                TabBarButton(systemIconName: "person.fill", label: "Профиль", isSelected: selectedTab == .profile) {
                    selectedTab = .profile
                }
                Spacer()
                TabBarButton(systemIconName: "trash.fill", label: "Корзина", isSelected: selectedTab == .cart) {
                    selectedTab = .cart
                }
                Spacer()
            }
            .frame(height: 80)
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct TabBarButton: View {
    let systemIconName: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .activeCategoryText : .gray)
                
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(isSelected ? .activeCategoryText : .gray)
            }
        }
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = 16
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct SuccessBannerView: View {
    let message: String
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(message)
                .font(.system(size: 13))
                .fontWeight(.semibold)
                .foregroundColor(.green)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(20)
        .frame(height: 50)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppStateManager())
    }
}
