//
//  HomeViewModel.swift
//  greeksms
//
//  Created by Tyler Zastrow on 5/8/24.
//

// HomeViewModel.swift
// greeksms
// Created by Tyler Zastrow on 5/8/24.

import SwiftUI

struct QuickMessageButton: Identifiable, Codable {
    let id: String
    var groupID: String
    var title: String
    var subtitle: String
    var color: Color

    // Use Codable to handle the Color property manually
    enum CodingKeys: String, CodingKey {
        case id, groupID, title, subtitle, colorComponents
    }

    init(id: String, groupID: String, title: String, subtitle: String, color: Color = .green) {
        self.id = id
        self.groupID = groupID
        self.title = title
        self.subtitle = subtitle
        self.color = color
    }

    // Encode and decode Color as an array of components (red, green, blue, opacity)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        groupID = try container.decode(String.self, forKey: .groupID)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)

        let colorComponents = try container.decode([Double].self, forKey: .colorComponents)
        self.color = Color(
            red: colorComponents[0],
            green: colorComponents[1],
            blue: colorComponents[2],
            opacity: colorComponents[3]
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(groupID, forKey: .groupID)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)

        // Extract color components for encoding
        if let cgColor = color.cgColor {
            let colorComponents = cgColor.components ?? [0, 0, 0, 0]
            try container.encode(colorComponents, forKey: .colorComponents)
        }
    }
}


class HomeViewModel: ObservableObject {
    @Published var quickMessageButtons: [QuickMessageButton] = []
    @Published var showingCustomizeScreen = false

    private var userDefaultsKey = "QuickMessageButtons"

    init() {
        loadQuickMessageButtons()
    }

    func addQuickMessageButton(button: QuickMessageButton) {
        quickMessageButtons.append(button)
        saveQuickMessageButtons()
    }

    func loadQuickMessageButtons() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedButtons = try? JSONDecoder().decode([QuickMessageButton].self, from: data) {
            quickMessageButtons = savedButtons
        }
    }

    func saveQuickMessageButtons() {
        if let data = try? JSONEncoder().encode(quickMessageButtons) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

