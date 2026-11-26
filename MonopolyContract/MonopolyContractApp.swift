import CryptoKit
import Foundation
import Observation
import SwiftUI
enum Catalog {
    static let maxPlayers = 10
    static let startingCash = 1500

    static let playerColors: [(name: String, hex: String)] = [
        ("red", "#c62828"),
        ("blue", "#1565c0"),
        ("green", "#2e7d32"),
        ("yellow", "#f9a825"),
        ("orange", "#ef6c00"),
        ("purple", "#6a1b9a"),
        ("black", "#212121"),
        ("brown", "#6d4c41"),
        ("pink", "#e56aa8"),
        ("teal", "#128a8a"),
    ]

    static let properties: [BoardProperty] = [
        BoardProperty(id: "mediterranean", name: "Mediterranean Avenue", colorGroup: "brown", colorHex: "#8B5A2B", kind: "street", basePrice: 60),
        BoardProperty(id: "baltic", name: "Baltic Avenue", colorGroup: "brown", colorHex: "#8B5A2B", kind: "street", basePrice: 60),
        BoardProperty(id: "oriental", name: "Oriental Avenue", colorGroup: "light_blue", colorHex: "#A6D8F0", kind: "street", basePrice: 100),
        BoardProperty(id: "vermont", name: "Vermont Avenue", colorGroup: "light_blue", colorHex: "#A6D8F0", kind: "street", basePrice: 100),
        BoardProperty(id: "connecticut", name: "Connecticut Avenue", colorGroup: "light_blue", colorHex: "#A6D8F0", kind: "street", basePrice: 120),
        BoardProperty(id: "st_charles", name: "St. Charles Place", colorGroup: "pink", colorHex: "#E07AB0", kind: "street", basePrice: 140),
        BoardProperty(id: "states", name: "States Avenue", colorGroup: "pink", colorHex: "#E07AB0", kind: "street", basePrice: 140),
        BoardProperty(id: "virginia", name: "Virginia Avenue", colorGroup: "pink", colorHex: "#E07AB0", kind: "street", basePrice: 160),
        BoardProperty(id: "st_james", name: "St. James Place", colorGroup: "orange", colorHex: "#F7941D", kind: "street", basePrice: 180),
        BoardProperty(id: "tennessee", name: "Tennessee Avenue", colorGroup: "orange", colorHex: "#F7941D", kind: "street", basePrice: 180),
        BoardProperty(id: "new_york", name: "New York Avenue", colorGroup: "orange", colorHex: "#F7941D", kind: "street", basePrice: 200),
        BoardProperty(id: "kentucky", name: "Kentucky Avenue", colorGroup: "red", colorHex: "#ED1C24", kind: "street", basePrice: 220),
        BoardProperty(id: "indiana", name: "Indiana Avenue", colorGroup: "red", colorHex: "#ED1C24", kind: "street", basePrice: 220),
        BoardProperty(id: "illinois", name: "Illinois Avenue", colorGroup: "red", colorHex: "#ED1C24", kind: "street", basePrice: 240),
        BoardProperty(id: "atlantic", name: "Atlantic Avenue", colorGroup: "yellow", colorHex: "#E6C200", kind: "street", basePrice: 260),
        BoardProperty(id: "ventnor", name: "Ventnor Avenue", colorGroup: "yellow", colorHex: "#E6C200", kind: "street", basePrice: 260),
        BoardProperty(id: "marvin_gardens", name: "Marvin Gardens", colorGroup: "yellow", colorHex: "#E6C200", kind: "street", basePrice: 280),
        BoardProperty(id: "pacific", name: "Pacific Avenue", colorGroup: "green", colorHex: "#1B8A3A", kind: "street", basePrice: 300),
        BoardProperty(id: "north_carolina", name: "North Carolina Avenue", colorGroup: "green", colorHex: "#1B8A3A", kind: "street", basePrice: 300),
        BoardProperty(id: "pennsylvania_ave", name: "Pennsylvania Avenue", colorGroup: "green", colorHex: "#1B8A3A", kind: "street", basePrice: 320),
        BoardProperty(id: "park_place", name: "Park Place", colorGroup: "dark_blue", colorHex: "#1A3E8A", kind: "street", basePrice: 350),
        BoardProperty(id: "boardwalk", name: "Boardwalk", colorGroup: "dark_blue", colorHex: "#1A3E8A", kind: "street", basePrice: 400),
        BoardProperty(id: "reading_railroad", name: "Reading Railroad", colorGroup: "railroad", colorHex: "#4A4A4A", kind: "railroad", basePrice: 200),
        BoardProperty(id: "penn_railroad", name: "Pennsylvania Railroad", colorGroup: "railroad", colorHex: "#4A4A4A", kind: "railroad", basePrice: 200),
        BoardProperty(id: "bo_railroad", name: "B&O Railroad", colorGroup: "railroad", colorHex: "#4A4A4A", kind: "railroad", basePrice: 200),
        BoardProperty(id: "short_line", name: "Short Line", colorGroup: "railroad", colorHex: "#4A4A4A", kind: "railroad", basePrice: 200),
        BoardProperty(id: "electric", name: "Electric Company", colorGroup: "utility", colorHex: "#C4A035", kind: "utility", basePrice: 150),
        BoardProperty(id: "water", name: "Water Works", colorGroup: "utility", colorHex: "#C4A035", kind: "utility", basePrice: 150),
    ]

    static func property(_ id: String) -> BoardProperty? {
        properties.first { $0.id == id }
    }

    static func playerHex(_ name: String) -> String {
        playerColors.first { $0.name == name }?.hex ?? "#212121"
    }

    static func money(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "$\(text)"
    }

    static func money(_ amount: Double) -> String {
        if amount.rounded() == amount {
            return money(Int(amount))
        }
        return String(format: "$%.2f", amount)
    }

    /// Principal plus a percent. "10" and "10%" both mean ten percent.
    static func loanMath(amount: Int?, interest: String) -> String {
        guard let amount, amount > 0 else { return "" }
        let cleaned = interest.replacingOccurrences(of: "%", with: "").trimmingCharacters(in: .whitespaces)
        guard let rate = Double(cleaned), !cleaned.isEmpty else { return "" }
        let extra = (Double(amount) * rate / 100 * 100).rounded() / 100
        let total = Double(amount) + extra
        return "\(money(amount)) + \(money(extra)) interest = \(money(total)) total"
    }
}

struct BoardProperty: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var colorGroup: String
    var colorHex: String
    var kind: String
    var basePrice: Int
}

struct GameError: LocalizedError {
    var message: String
    var errorDescription: String? { message }
    static func say(_ text: String) -> GameError { GameError(message: text) }
}

struct Account: Identifiable, Codable, Hashable {
    var id: String
    var username: String
    var usernameKey: String
    var passwordHash: String
    var token: String
    var notes: [QuickNote]
}

struct QuickNote: Identifiable, Codable, Hashable {
    var id: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
}

struct TableRecord: Identifiable, Codable, Hashable {
    var id: String
    var code: String
    var createdAt: Date
}

struct Seat: Identifiable, Codable, Hashable {
    var id: String
    var tableId: String
    var displayName: String
    var color: String
    var token: String
    var cash: Int
    var isHost: Bool
    var removed: Bool
    var accountId: String?
}

struct Ownership: Codable, Hashable {
    var tableId: String
    var propertyId: String
    var ownerId: String?
}

struct Share: Codable, Hashable {
    var tableId: String
    var propertyId: String
    var playerId: String
    var percent: Int
}

struct DealContract: Identifiable, Codable, Hashable {
    var id: String
    var tableId: String
    var propertyIds: [String]
    var title: String
    var body: String
    var obligorId: String
    var obligorName: String
    var recipientId: String?
    var recipientName: String?
    var accepted: Bool
    var queued: Bool
    var obligorEnd: Bool
    var recipientEnd: Bool
    var endRequestedAt: Date?
    var stayForId: String?
    var active: Bool
    var createdAt: Date
}

struct Listing: Identifiable, Codable, Hashable {
    var id: String
    var tableId: String
    var sellerId: String
    var sellerName: String
    var sellerColor: String
    var offerKind: String
    var propertyIds: [String]
    var askingPrice: Int?
    var loanAmount: Int?
    var interest: String
    var details: String
    var wanted: String
    var status: String
    var version: Int
    var createdAt: Date
    var updatedAt: Date
}

struct Offer: Identifiable, Codable, Hashable {
    var id: String
    var listingId: String
    var tableId: String
    var buyerId: String
    var buyerName: String
    var fromId: String
    var fromName: String
    var cash: Int
    var propertyIds: [String]
    var equityPercent: Int
    var customTerms: String
    var status: String
    var listingVersion: Int
    var createdAt: Date
}

struct DealSignature: Codable, Hashable, Identifiable {
    var playerId: String
    var playerName: String
    var role: String
    var signedAt: Date?
    var paidAt: Date?
    var id: String { playerId }
}

struct Agreement: Identifiable, Codable, Hashable {
    var id: String
    var offerId: String
    var listingId: String
    var tableId: String
    var buyerId: String
    var sellerId: String
    var status: String
    var conditions: String
    var signatures: [DealSignature]
    var createdAt: Date
    var completedAt: Date?
}

struct ChatMessage: Identifiable, Codable, Hashable {
    var id: String
    var tableId: String
    var senderId: String?
    var senderName: String
    var recipientId: String?
    var body: String
    var kind: String
    var createdAt: Date
}

struct PassMark: Codable, Hashable {
    var playerId: String
    var listingId: String
}

struct SeenBook: Codable, Hashable {
    var receiving: [String: [String]] = [:]
    var chat: [String: [String: Date]] = [:]
}

struct Database: Codable {
    var accounts: [Account] = []
    var tables: [TableRecord] = []
    var seats: [Seat] = []
    var ownership: [Ownership] = []
    var shares: [Share] = []
    var contracts: [DealContract] = []
    var listings: [Listing] = []
    var offers: [Offer] = []
    var agreements: [Agreement] = []
    var messages: [ChatMessage] = []
    var passes: [PassMark] = []
    var seen: SeenBook = SeenBook()
}

extension Color {
    init(hex: String) {
        var text = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.hasPrefix("#") { text.removeFirst() }
        var value: UInt64 = 0
        Scanner(string: text).scanHexInt64(&value)
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }

    static let paper = Color(hex: "#f6f1e7")
    static let card = Color(hex: "#fffdf8")
    static let ink = Color(hex: "#1c1915")
    static let muted = Color(hex: "#5e584f")
    static let line = Color(hex: "#e4d8c4")
    static let pine = Color(hex: "#143d32")
    static let gold = Color(hex: "#a56b12")
    static let danger = Color(hex: "#8d2b2b")
}

struct PaperScreen<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            Color.paper.ignoresSafeArea()
            content
        }
        .foregroundStyle(Color.ink)
    }
}

struct GreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(Color.pine)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct GhostButton: ButtonStyle {
    var tint: Color = .ink
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(Color.card)
            .foregroundStyle(tint)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.line, lineWidth: 1))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct CardBox<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.card)
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.line, lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct FieldLabel: View {
    var title: String
    var body: some View {
        Text(title).font(.subheadline.weight(.semibold))
    }
}

struct ColorBar: View {
    var hex: String
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(hex: hex))
            .frame(width: 8, height: 22)
    }
}

struct PlayerDot: View {
    var color: String
    var body: some View {
        Circle()
            .fill(Color(hex: Catalog.playerHex(color)))
            .frame(width: 14, height: 14)
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
    }
}

/// Standalone rules for Monopoly Contract. The phone keeps the table.
/// Cash is stored and never shown or moved. Deeds move only after both sides sign and confirm the handoff.
@MainActor
@Observable
final class GameStore {
    private(set) var db = Database()
    var accountToken: String?
    var seatId: String?
    var playing = false
    var banner: String?

    private let seatKey = "monopolyContractSeat"
    private let accountKey = "monopolyContractAccount"

    init() {
        load()
        accountToken = UserDefaults.standard.string(forKey: accountKey)
        seatId = UserDefaults.standard.string(forKey: seatKey)
        if account == nil { accountToken = nil }
        if me == nil { seatId = nil }
    }

    var account: Account? { db.accounts.first { $0.token == accountToken } }
    var me: Seat? { db.seats.first { $0.id == seatId && !$0.removed } }
    var table: TableRecord? { db.tables.first { $0.id == me?.tableId } }

    var seated: [Seat] {
        guard let table else { return [] }
        let others = db.seats.filter { $0.tableId == table.id && !$0.removed && $0.id != me?.id }
        if let me { return [me] + others }
        return others
    }

    // MARK: Accounts

    func register(username: String, password: String) throws {
        let name = try cleanUsername(username)
        let secret = try cleanPassword(password)
        if db.accounts.contains(where: { $0.usernameKey == name.fold }) {
            throw GameError.say("That username is already used.")
        }
        let account = Account(
            id: UUID().uuidString,
            username: name,
            usernameKey: name.fold,
            passwordHash: hash(secret),
            token: UUID().uuidString,
            notes: []
        )
        db.accounts.append(account)
        accountToken = account.token
        save()
    }

    func login(username: String, password: String) throws {
        let key = username.trimmingCharacters(in: .whitespacesAndNewlines).fold
        guard let found = db.accounts.first(where: { $0.usernameKey == key }),
              verify(password, hash: found.passwordHash) else {
            throw GameError.say("That username or password is wrong.")
        }
        accountToken = found.token
        save()
    }

    func signOutAccount() {
        accountToken = nil
        UserDefaults.standard.removeObject(forKey: accountKey)
    }

    func addNote(_ body: String) throws {
        let text = try cleanNote(body)
        guard var current = account, let index = accountIndex else {
            throw GameError.say("Sign in to keep a quick note.")
        }
        if let existing = current.notes.firstIndex(where: { $0.body == text }) {
            current.notes[existing].updatedAt = Date()
        } else {
            current.notes.insert(QuickNote(id: UUID().uuidString, body: text, createdAt: Date(), updatedAt: Date()), at: 0)
            if current.notes.count > 24 { current.notes = Array(current.notes.prefix(24)) }
        }
        db.accounts[index] = current
        save()
    }

    func updateNote(id: String, body: String) throws {
        let text = try cleanNote(body)
        guard var current = account, let index = accountIndex, let note = current.notes.firstIndex(where: { $0.id == id }) else {
            throw GameError.say("That quick note is not yours.")
        }
        current.notes[note].body = text
        current.notes[note].updatedAt = Date()
        db.accounts[index] = current
        save()
    }

    func deleteNote(id: String) throws {
        guard var current = account, let index = accountIndex else {
            throw GameError.say("That quick note is not yours.")
        }
        let before = current.notes.count
        current.notes.removeAll { $0.id == id }
        if current.notes.count == before { throw GameError.say("That quick note is not yours.") }
        db.accounts[index] = current
        save()
    }

    // MARK: Tables

    func createTable(code raw: String) throws {
        let code: String
        if raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            code = try freshCode()
        } else {
            code = try cleanCode(raw)
            if db.tables.contains(where: { $0.code == code }) {
                throw GameError.say("That code is already used.")
            }
        }
        let table = TableRecord(id: UUID().uuidString, code: code, createdAt: Date())
        db.tables.append(table)
        for property in Catalog.properties {
            db.ownership.append(Ownership(tableId: table.id, propertyId: property.id, ownerId: nil))
        }
        let name = account?.username ?? "Player"
        let color = firstFreeColor(table.id)
        let seat = newSeat(tableId: table.id, name: name, color: color, host: true)
        db.seats.append(seat)
        enter(seat)
    }

    func join(code raw: String, name rawName: String, color: String) throws {
        let code = try cleanCode(raw)
        guard let table = db.tables.first(where: { $0.code == code }) else {
            throw GameError.say("No table uses that code.")
        }
        if let account, let existing = db.seats.first(where: { $0.tableId == table.id && !$0.removed && $0.accountId == account.id }) {
            enter(existing)
            return
        }
        if let restored = try restoreSeat(tableId: table.id, name: rawName, color: color) {
            enter(restored)
            return
        }
        let name = try cleanDisplayName(rawName)
        let active = db.seats.filter { $0.tableId == table.id && !$0.removed }
        if active.count >= Catalog.maxPlayers { throw GameError.say("This table is full.") }
        if active.contains(where: { $0.color == color }) { throw GameError.say("That color is taken.") }
        guard Catalog.playerColors.contains(where: { $0.name == color }) else {
            throw GameError.say("Pick a color.")
        }
        let seat = newSeat(tableId: table.id, name: name, color: color, host: false)
        db.seats.append(seat)
        enter(seat)
    }

    func continuePlaying() {
        if me != nil { playing = true }
    }

    func leave() {
        guard let index = seatIndex else { return }
        db.seats[index].removed = true
        db.seats[index].token = UUID().uuidString
        seatId = nil
        playing = false
        UserDefaults.standard.removeObject(forKey: seatKey)
        save()
    }

    func useSeat(_ id: String) {
        guard let seat = db.seats.first(where: { $0.id == id && !$0.removed && $0.tableId == table?.id }) else { return }
        enter(seat)
    }

    func preview(code raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard trimmed.count == 4, let code = try? cleanCode(trimmed), let table = db.tables.first(where: { $0.code == code }) else {
            return trimmed.count == 4 ? "No table uses that code." : "Enter a code to see who is already sitting down."
        }
        let names = db.seats.filter { $0.tableId == table.id && !$0.removed }.map(\.displayName)
        return names.isEmpty ? "Nobody is sitting down yet." : names.joined(separator: ", ")
    }

    func takenColors(code raw: String) -> [String] {
        guard let code = try? cleanCode(raw), let table = db.tables.first(where: { $0.code == code }) else { return [] }
        return db.seats.filter { $0.tableId == table.id && !$0.removed }.map(\.color)
    }

    // MARK: Marketplace

    func visibleListings() -> [Listing] {
        guard let me else { return [] }
        return db.listings.filter { listing in
            listing.tableId == me.tableId
                && listing.status != "withdrawn"
                && listing.status != "sold"
                && !db.passes.contains { $0.playerId == me.id && $0.listingId == listing.id }
        }
    }

    func sellerAlert(_ listing: Listing) -> Bool {
        guard let me else { return false }
        return listing.sellerId == me.id && listing.status == "pending_sale"
    }

    func listingTitle(_ listing: Listing) -> String {
        if !listing.propertyIds.isEmpty {
            return listing.propertyIds.compactMap { Catalog.property($0)?.name }.joined(separator: ", ")
        }
        let amount = listing.loanAmount ?? listing.askingPrice ?? 0
        if listing.offerKind == "loan" { return "Cash loan \(Catalog.money(amount))" }
        return "Cash \(Catalog.money(amount))"
    }

    func listableProperties() -> [BoardProperty] {
        guard let me else { return [] }
        return Catalog.properties.filter { property in
            let owner = ownerId(property.id)
            return owner == nil || owner == me.id
        }
    }

    func createListing(kind: String, propertyIds: [String], askingPrice: Int?, loanAmount: Int?, interest: String, details: String, wanted: String) throws {
        guard let me else { throw GameError.say("Join a table first.") }
        if kind == "property" {
            if propertyIds.isEmpty { throw GameError.say("Select at least one property") }
        } else if kind == "loan" {
            guard let loanAmount, loanAmount >= 1 else { throw GameError.say("Add the amount.") }
            if interest.trimmingCharacters(in: .whitespaces).isEmpty { throw GameError.say("Add the interest or the terms") }
        } else {
            throw GameError.say("Choose property or a cash loan")
        }
        var ids: [String] = []
        if kind == "property" {
            for id in propertyIds where !ids.contains(id) {
                guard Catalog.property(id) != nil else { throw GameError.say("Unknown property") }
                if let owner = ownerId(id), owner != me.id { throw GameError.say("You do not own \(Catalog.property(id)?.name ?? "that")") }
                if db.listings.contains(where: { $0.tableId == me.tableId && $0.propertyIds.contains(id) && $0.status != "withdrawn" && $0.status != "sold" }) {
                    throw GameError.say("\(Catalog.property(id)?.name ?? "That") is already on the table")
                }
                if ownerId(id) == nil { claim(id, by: me) }
                ids.append(id)
            }
        }
        let price = kind == "property" ? askingPrice : loanAmount
        if kind == "loan", price == nil { throw GameError.say("Add the amount.") }
        let listing = Listing(
            id: UUID().uuidString,
            tableId: me.tableId,
            sellerId: me.id,
            sellerName: me.displayName,
            sellerColor: me.color,
            offerKind: kind,
            propertyIds: ids,
            askingPrice: price,
            loanAmount: kind == "loan" ? loanAmount : nil,
            interest: kind == "loan" ? interest : "",
            details: details,
            wanted: wanted,
            status: "active",
            version: 1,
            createdAt: Date(),
            updatedAt: Date()
        )
        db.listings.append(listing)
        let label = kind == "loan" ? "a \(Catalog.money(loanAmount ?? 0)) loan" : listingTitle(listing)
        postSystem("\(me.displayName) put \(label) on the table.")
        save()
    }

    func updateListing(id: String, price: Int?, details: String, wanted: String) throws {
        guard let me, let index = db.listings.firstIndex(where: { $0.id == id && $0.tableId == me.tableId }) else {
            throw GameError.say("Listing not found")
        }
        if db.listings[index].sellerId != me.id { throw GameError.say("Only the seller can edit this listing") }
        db.listings[index].askingPrice = price
        if db.listings[index].offerKind != "property" { db.listings[index].loanAmount = price }
        db.listings[index].details = details
        db.listings[index].wanted = wanted
        db.listings[index].version += 1
        db.listings[index].updatedAt = Date()
        if db.listings[index].status == "pending_sale" { db.listings[index].status = "active" }
        voidDeals(listingId: id)
        save()
    }

    func withdrawListing(id: String) throws {
        guard let me, let index = db.listings.firstIndex(where: { $0.id == id && $0.sellerId == me.id }) else {
            throw GameError.say("Only the seller can take this off the table")
        }
        db.listings[index].status = "withdrawn"
        voidDeals(listingId: id)
        save()
    }

    func passListing(id: String) {
        guard let me else { return }
        if !db.passes.contains(where: { $0.playerId == me.id && $0.listingId == id }) {
            db.passes.append(PassMark(playerId: me.id, listingId: id))
            save()
        }
    }

    func acceptTerms(listingId: String) throws {
        guard let me, let index = db.listings.firstIndex(where: { $0.id == listingId && $0.tableId == me.tableId }) else {
            throw GameError.say("Listing not found")
        }
        let listing = db.listings[index]
        if listing.sellerId == me.id { throw GameError.say("You cannot buy your own listing") }
        if listing.status != "active" { throw GameError.say("This listing is not taking offers") }
        if listing.offerKind == "loan" || listing.offerKind == "cash" {
            let offer = Offer(
                id: UUID().uuidString, listingId: listing.id, tableId: me.tableId,
                buyerId: me.id, buyerName: me.displayName, fromId: me.id, fromName: me.displayName,
                cash: listing.loanAmount ?? listing.askingPrice ?? 0, propertyIds: [], equityPercent: 0,
                customTerms: listing.interest, status: "accepted", listingVersion: listing.version, createdAt: Date()
            )
            db.offers.append(offer)
            db.agreements.append(makeAgreement(listing: listing, offer: offer))
            db.listings[index].status = "pending_sale"
            db.listings[index].updatedAt = Date()
            banner = "You accepted the terms. Nothing moves until both sides sign and confirm payment."
        } else {
            guard let price = listing.askingPrice else { throw GameError.say("The seller is taking offers, not a set price.") }
            if db.offers.contains(where: { $0.listingId == listing.id && $0.buyerId == me.id && $0.status == "pending" }) {
                throw GameError.say("You already have an offer waiting on this listing")
            }
            db.offers.append(Offer(
                id: UUID().uuidString, listingId: listing.id, tableId: me.tableId,
                buyerId: me.id, buyerName: me.displayName, fromId: me.id, fromName: me.displayName,
                cash: price, propertyIds: [], equityPercent: 0, customTerms: "", status: "pending",
                listingVersion: listing.version, createdAt: Date()
            ))
            banner = "Offer sent at \(Catalog.money(price)). Nothing transfers until the seller accepts and the deal is signed and paid."
        }
        save()
    }

    func makeOffer(listingId: String, cash: Int, propertyIds: [String], equity: Int, terms: String) throws {
        guard let me, let listing = db.listings.first(where: { $0.id == listingId && $0.tableId == me.tableId }) else {
            throw GameError.say("Listing not found")
        }
        if listing.sellerId == me.id { throw GameError.say("You cannot buy your own listing") }
        if listing.status != "active" { throw GameError.say("This listing is not taking offers") }
        if cash == 0 && propertyIds.isEmpty && equity == 0 && terms.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw GameError.say("Add cash, property, equity, or custom terms")
        }
        for id in propertyIds {
            if ownerId(id) != me.id { throw GameError.say("You can only offer deeds you own.") }
            if listing.propertyIds.contains(id) { throw GameError.say("That deed is the one being sold.") }
        }
        db.offers.append(Offer(
            id: UUID().uuidString, listingId: listing.id, tableId: me.tableId,
            buyerId: me.id, buyerName: me.displayName, fromId: me.id, fromName: me.displayName,
            cash: cash, propertyIds: propertyIds, equityPercent: equity, customTerms: terms,
            status: "pending", listingVersion: listing.version, createdAt: Date()
        ))
        banner = "Offer sent. Nothing has transferred."
        save()
    }

    func offers(for listingId: String) -> [Offer] {
        guard let me else { return [] }
        return db.offers.filter { offer in
            offer.listingId == listingId && offer.status != "rejected" && (offer.buyerId == me.id || db.listings.first { $0.id == listingId }?.sellerId == me.id)
        }
    }

    func acceptOffer(id: String) throws {
        guard let me, let index = db.offers.firstIndex(where: { $0.id == id }) else { throw GameError.say("Offer not found") }
        let offer = db.offers[index]
        guard let listingIndex = db.listings.firstIndex(where: { $0.id == offer.listingId }), db.listings[listingIndex].sellerId == me.id else {
            throw GameError.say("Only the seller can accept this offer")
        }
        if offer.status != "pending" { throw GameError.say("That offer is no longer open") }
        db.offers[index].status = "accepted"
        let listing = db.listings[listingIndex]
        db.agreements.append(makeAgreement(listing: listing, offer: db.offers[index]))
        db.listings[listingIndex].status = "pending_sale"
        db.listings[listingIndex].updatedAt = Date()
        save()
    }

    func rejectOffer(id: String) throws {
        guard let me, let index = db.offers.firstIndex(where: { $0.id == id }) else { throw GameError.say("Offer not found") }
        if db.offers[index].fromId != me.id { throw GameError.say("Only the player who made this offer can take it off") }
        db.offers[index].status = "rejected"
        save()
    }

    func agreement(for listingId: String) -> Agreement? {
        guard let me else { return nil }
        return db.agreements.first { item in
            item.listingId == listingId && (item.status == "awaiting_signatures" || item.status == "awaiting_payment")
                && (item.buyerId == me.id || item.sellerId == me.id)
        }
    }

    func sign(agreementId: String) throws {
        guard let me, let index = db.agreements.firstIndex(where: { $0.id == agreementId }) else { throw GameError.say("Deal not found") }
        guard let sig = db.agreements[index].signatures.firstIndex(where: { $0.playerId == me.id }) else {
            throw GameError.say("You are not part of this deal")
        }
        db.agreements[index].signatures[sig].signedAt = Date()
        if db.agreements[index].signatures.allSatisfy({ $0.signedAt != nil }) {
            db.agreements[index].status = "awaiting_payment"
        }
        save()
    }

    func confirmHandoff(agreementId: String) throws {
        guard let me, let index = db.agreements.firstIndex(where: { $0.id == agreementId }) else { throw GameError.say("Deal not found") }
        guard db.agreements[index].status == "awaiting_payment" else { throw GameError.say("Both players still need to sign.") }
        guard let sig = db.agreements[index].signatures.firstIndex(where: { $0.playerId == me.id }) else {
            throw GameError.say("You are not part of this deal")
        }
        db.agreements[index].signatures[sig].paidAt = Date()
        guard db.agreements[index].signatures.allSatisfy({ $0.paidAt != nil }) else {
            save()
            return
        }
        let deal = db.agreements[index]
        if let offer = db.offers.first(where: { $0.id == deal.offerId }),
           let listing = db.listings.first(where: { $0.id == deal.listingId }) {
            for propertyId in listing.propertyIds {
                setOwner(propertyId, to: deal.buyerId, tableId: deal.tableId)
                if offer.equityPercent > 0 {
                    setShare(propertyId, player: deal.sellerId, percent: offer.equityPercent, tableId: deal.tableId)
                    setShare(propertyId, player: deal.buyerId, percent: 100 - offer.equityPercent, tableId: deal.tableId)
                }
            }
            for propertyId in offer.propertyIds {
                setOwner(propertyId, to: deal.sellerId, tableId: deal.tableId)
            }
        }
        if let listingIndex = db.listings.firstIndex(where: { $0.id == deal.listingId }) {
            db.listings[listingIndex].status = "sold"
        }
        db.agreements[index].status = "completed"
        db.agreements[index].completedAt = Date()
        save()
    }

    func declineDeal(agreementId: String) throws {
        guard let me, let index = db.agreements.firstIndex(where: { $0.id == agreementId }) else { throw GameError.say("Deal not found") }
        let deal = db.agreements[index]
        guard deal.buyerId == me.id || deal.sellerId == me.id else { throw GameError.say("You are not part of this deal") }
        db.agreements[index].status = "declined"
        if let listingIndex = db.listings.firstIndex(where: { $0.id == deal.listingId && $0.status == "pending_sale" }) {
            db.listings[listingIndex].status = "active"
        }
        save()
    }

    // MARK: Contracts

    func visibleContracts() -> [DealContract] {
        guard let me else { return [] }
        return db.contracts.filter { contract in
            guard contract.tableId == me.tableId && contract.active else { return false }
            if contract.queued { return contract.obligorId == me.id }
            if let recipient = contract.recipientId {
                return contract.obligorId == me.id || recipient == me.id
            }
            return contract.obligorId == me.id
        }
    }

    func sendContract(propertyIds: [String], recipientId: String, body: String, queued: Bool, priorId: String?) throws {
        guard let me else { throw GameError.say("Join a table first.") }
        var text = body.trimmingCharacters(in: .whitespacesAndNewlines)
        if !queued && text.isEmpty { throw GameError.say("Write the contract note.") }
        if text.count > 2000 { throw GameError.say("Keep the note under 2000 characters.") }
        if propertyIds.isEmpty { throw GameError.say("Pick a property") }
        guard let recipient = db.seats.first(where: { $0.id == recipientId && $0.tableId == me.tableId && !$0.removed }), recipient.id != me.id else {
            throw GameError.say("Pick another player")
        }
        if let priorId {
            guard let prior = db.contracts.first(where: { $0.id == priorId && $0.tableId == me.tableId && $0.active }),
                  prior.obligorId == me.id || prior.recipientId == me.id else {
                throw GameError.say("Contract not found")
            }
            if prior.accepted { throw GameError.say("That contract is already accepted") }
            if !prior.body.isEmpty && !text.contains(prior.body) {
                text = prior.body.trimmingCharacters(in: .whitespacesAndNewlines) + "\n" + text
            }
            if let priorIndex = db.contracts.firstIndex(where: { $0.id == priorId }) {
                db.contracts[priorIndex].active = false
            }
        }
        let names = propertyIds.compactMap { Catalog.property($0)?.name }
        var title = names.joined(separator: ", ")
        if title.count > 80 { title = String(title.prefix(77)) + "..." }
        db.contracts.append(DealContract(
            id: UUID().uuidString, tableId: me.tableId, propertyIds: propertyIds, title: title, body: text,
            obligorId: me.id, obligorName: me.displayName, recipientId: recipient.id, recipientName: recipient.displayName,
            accepted: false, queued: queued, obligorEnd: false, recipientEnd: false, endRequestedAt: nil, stayForId: nil,
            active: true, createdAt: Date()
        ))
        if let account, text.count <= 200, !queued, !text.isEmpty {
            try? addNote(text)
        }
        save()
    }

    func acceptContract(id: String) throws {
        guard let me, let index = db.contracts.firstIndex(where: { $0.id == id && $0.active }) else { throw GameError.say("Contract not found") }
        if db.contracts[index].queued { throw GameError.say("That offer has not been sent") }
        if db.contracts[index].recipientId != me.id { throw GameError.say("Only the player who received this offer can accept it") }
        db.contracts[index].accepted = true
        save()
    }

    func denyContract(id: String) throws {
        guard let me, let index = db.contracts.firstIndex(where: { $0.id == id && $0.active }) else { throw GameError.say("Contract not found") }
        if db.contracts[index].recipientId != me.id { throw GameError.say("Only the player who received this offer can deny it") }
        db.contracts[index].active = false
        save()
    }

    func unsendContract(id: String) throws {
        guard let me, let index = db.contracts.firstIndex(where: { $0.id == id && $0.active }) else { throw GameError.say("Contract not found") }
        if db.contracts[index].obligorId != me.id { throw GameError.say("Only the player who sent this contract can unsend it") }
        if db.contracts[index].accepted { throw GameError.say("That contract is already accepted") }
        db.contracts[index].active = false
        save()
    }

    enum EndResult { case waiting, removed, expired }

    func exterminate(id: String) throws -> EndResult {
        guard let me, let index = db.contracts.firstIndex(where: { $0.id == id && $0.active }) else { throw GameError.say("Contract not found") }
        var row = db.contracts[index]
        if row.queued || !row.accepted { throw GameError.say("Only an accepted contract can be exterminated") }
        guard row.obligorId == me.id || row.recipientId == me.id else { throw GameError.say("Only the two players on this contract can exterminate it") }
        if let stamp = row.endRequestedAt, Date().timeIntervalSince(stamp) > 10 {
            row.obligorEnd = false
            row.recipientEnd = false
            row.endRequestedAt = nil
            db.contracts[index] = row
            save()
            return .expired
        }
        if row.obligorId == me.id { row.obligorEnd = true } else { row.recipientEnd = true }
        let removed = row.obligorEnd && row.recipientEnd
        if row.endRequestedAt == nil { row.endRequestedAt = Date() }
        if removed {
            row.active = false
            row.endRequestedAt = nil
        }
        db.contracts[index] = row
        save()
        return removed ? .removed : .waiting
    }

    func tick() {
        guard me != nil else { return }
        var changed = false
        for index in db.contracts.indices {
            guard let stamp = db.contracts[index].endRequestedAt, Date().timeIntervalSince(stamp) > 10, db.contracts[index].active else { continue }
            let row = db.contracts[index]
            let waitingId = row.obligorEnd ? row.recipientId : row.obligorId
            db.contracts[index].obligorEnd = false
            db.contracts[index].recipientEnd = false
            db.contracts[index].endRequestedAt = nil
            db.contracts[index].stayForId = waitingId
            changed = true
        }
        if changed { save() }
    }

    func clearStay(_ id: String) {
        guard let index = db.contracts.firstIndex(where: { $0.id == id }) else { return }
        db.contracts[index].stayForId = nil
        save()
    }

    func incomingExterminate() -> DealContract? {
        guard let me else { return nil }
        return db.contracts.first { contract in
            contract.active && contract.accepted && contract.endRequestedAt != nil && isParty(contract)
                && !myEnd(contract) && otherEnd(contract)
                && Date().timeIntervalSince(contract.endRequestedAt ?? .distantPast) <= 10
        }
    }

    func stayContract() -> DealContract? {
        guard let me else { return nil }
        return db.contracts.first { $0.stayForId == me.id && $0.active && $0.accepted }
    }

    var incomingAlert: Bool {
        guard let me else { return false }
        let seen = Set(db.seen.receiving[me.id] ?? [])
        return visibleContracts().contains { !$0.accepted && !$0.queued && $0.recipientId == me.id && !seen.contains($0.id) }
    }

    func markReceivingSeen() {
        guard let me else { return }
        let ids = visibleContracts().filter { !$0.accepted && !$0.queued && $0.recipientId == me.id }.map(\.id)
        db.seen.receiving[me.id] = ids
        save()
    }

    // MARK: Chat

    func messages(with playerId: String?) -> [ChatMessage] {
        guard let me else { return [] }
        return db.messages.filter { message in
            guard message.tableId == me.tableId else { return false }
            if let playerId {
                let pair = [message.senderId, message.recipientId]
                return message.recipientId != nil && pair.contains(me.id) && pair.contains(playerId)
            }
            return message.recipientId == nil
        }.sorted { $0.createdAt < $1.createdAt }
    }

    func sendChat(body: String, to playerId: String?) throws {
        guard let me else { throw GameError.say("Join a table first.") }
        let text = body.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { throw GameError.say("Write a message.") }
        if let playerId {
            guard db.seats.contains(where: { $0.id == playerId && $0.tableId == me.tableId && !$0.removed && $0.id != me.id }) else {
                throw GameError.say("That player is not at the table.")
            }
        }
        db.messages.append(ChatMessage(
            id: UUID().uuidString, tableId: me.tableId, senderId: me.id, senderName: me.displayName,
            recipientId: playerId, body: text, kind: "chat", createdAt: Date()
        ))
        save()
    }

    var chatAlert: Bool {
        guard let me else { return false }
        if let last = messages(with: nil).last, last.senderId != me.id, !seen(me.id, key: "group", at: last.createdAt) {
            return true
        }
        for other in seated where other.id != me.id {
            if let last = messages(with: other.id).last, last.senderId != me.id, !seen(me.id, key: other.id, at: last.createdAt) {
                return true
            }
        }
        return false
    }

    func markChat(group: Bool, playerId: String?) {
        guard let me else { return }
        let key = group ? "group" : (playerId ?? "")
        guard !key.isEmpty else { return }
        let latest = (group ? messages(with: nil) : messages(with: playerId)).last?.createdAt ?? Date()
        var book = db.seen.chat[me.id] ?? [:]
        book[key] = latest
        db.seen.chat[me.id] = book
        save()
    }

    func myEnd(_ contract: DealContract) -> Bool {
        guard let me else { return false }
        return contract.obligorId == me.id ? contract.obligorEnd : contract.recipientEnd
    }

    func otherEnd(_ contract: DealContract) -> Bool {
        guard let me else { return false }
        return contract.obligorId == me.id ? contract.recipientEnd : contract.obligorEnd
    }

    // MARK: Private

    private var accountIndex: Int? { db.accounts.firstIndex { $0.token == accountToken } }
    private var seatIndex: Int? { db.seats.firstIndex { $0.id == seatId } }

    private func isParty(_ contract: DealContract) -> Bool {
        guard let me else { return false }
        return contract.obligorId == me.id || contract.recipientId == me.id
    }

    private func seen(_ seat: String, key: String, at date: Date) -> Bool {
        guard let mark = db.seen.chat[seat]?[key] else { return false }
        return mark >= date
    }

    private func enter(_ seat: Seat) {
        seatId = seat.id
        playing = true
        UserDefaults.standard.set(seat.id, forKey: seatKey)
        save()
    }

    private func newSeat(tableId: String, name: String, color: String, host: Bool) -> Seat {
        Seat(
            id: UUID().uuidString, tableId: tableId, displayName: name, color: color,
            token: UUID().uuidString, cash: Catalog.startingCash, isHost: host, removed: false,
            accountId: account?.id
        )
    }

    private func restoreSeat(tableId: String, name: String, color: String) throws -> Seat? {
        let match: (Seat) -> Bool
        if let account {
            match = { $0.tableId == tableId && $0.removed && $0.accountId == account.id }
        } else {
            let folded = name.trimmingCharacters(in: .whitespacesAndNewlines).fold
            match = { $0.tableId == tableId && $0.removed && $0.accountId == nil && $0.displayName.fold == folded }
        }
        guard let index = db.seats.lastIndex(where: match) else { return nil }
        let active = db.seats.filter { $0.tableId == tableId && !$0.removed }
        if active.contains(where: { $0.color == color && $0.id != db.seats[index].id }) {
            throw GameError.say("That color is taken.")
        }
        db.seats[index].removed = false
        db.seats[index].color = color
        db.seats[index].token = UUID().uuidString
        if db.seats[index].accountId == nil { db.seats[index].accountId = account?.id }
        let typed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !typed.isEmpty { db.seats[index].displayName = String(typed.prefix(20)) }
        return db.seats[index]
    }

    private func firstFreeColor(_ tableId: String) -> String {
        let used = Set(db.seats.filter { $0.tableId == tableId && !$0.removed }.map(\.color))
        return Catalog.playerColors.first { !used.contains($0.name) }?.name ?? "red"
    }

    private func freshCode() throws -> String {
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        for _ in 0..<10 {
            let code = String((0..<4).map { _ in alphabet.randomElement()! })
            if !db.tables.contains(where: { $0.code == code }) { return code }
        }
        throw GameError.say("Could not make a code.")
    }

    func addPlayer(name: String, color: String) throws {
        guard let table, let keep = seatId else { throw GameError.say("Start a table first.") }
        try join(code: table.code, name: name, color: color)
        seatId = keep
        playing = true
        UserDefaults.standard.set(keep, forKey: seatKey)
        save()
    }

    private func cleanCode(_ raw: String) throws -> String {
        let code = raw.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let allowed = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if code.count != 4 || code.contains(where: { !allowed.contains($0) }) {
            throw GameError.say("Use a 4-character code.")
        }
        return code
    }

    private func cleanUsername(_ raw: String) throws -> String {
        let name = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty || name.count > 20 { throw GameError.say("Use a username of 1 to 20 characters.") }
        return name
    }

    private func cleanPassword(_ raw: String) throws -> String {
        if raw.count < 4 || raw.count > 64 { throw GameError.say("Use a password of 4 to 64 characters.") }
        return raw
    }

    private func cleanDisplayName(_ raw: String) throws -> String {
        let name = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty || name.count > 20 { throw GameError.say("Use a name of 1 to 20 characters.") }
        return name
    }

    private func cleanNote(_ raw: String) throws -> String {
        let text = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty || text.count > 200 { throw GameError.say("A quick note can be up to 200 characters.") }
        return text
    }

    private func ownerId(_ propertyId: String) -> String? {
        guard let me else { return nil }
        return db.ownership.first { $0.tableId == me.tableId && $0.propertyId == propertyId }?.ownerId
    }

    private func claim(_ propertyId: String, by seat: Seat) {
        if let index = db.ownership.firstIndex(where: { $0.tableId == seat.tableId && $0.propertyId == propertyId }) {
            db.ownership[index].ownerId = seat.id
        }
        db.shares.removeAll { $0.tableId == seat.tableId && $0.propertyId == propertyId }
        db.shares.append(Share(tableId: seat.tableId, propertyId: propertyId, playerId: seat.id, percent: 100))
    }

    private func setOwner(_ propertyId: String, to playerId: String, tableId: String) {
        if let index = db.ownership.firstIndex(where: { $0.tableId == tableId && $0.propertyId == propertyId }) {
            db.ownership[index].ownerId = playerId
        }
    }

    private func setShare(_ propertyId: String, player: String, percent: Int, tableId: String) {
        if let index = db.shares.firstIndex(where: { $0.tableId == tableId && $0.propertyId == propertyId && $0.playerId == player }) {
            db.shares[index].percent = percent
        } else {
            db.shares.append(Share(tableId: tableId, propertyId: propertyId, playerId: player, percent: percent))
        }
    }

    private func makeAgreement(listing: Listing, offer: Offer) -> Agreement {
        let math = Catalog.loanMath(amount: listing.loanAmount ?? listing.askingPrice, interest: listing.interest)
        var conditions = [listing.details, listing.wanted, offer.customTerms, math].filter { !$0.isEmpty }
        if offer.equityPercent > 0 { conditions.append("Seller keeps \(offer.equityPercent)% equity.") }
        if offer.cash > 0 && listing.offerKind == "property" { conditions.append("Cash named in the offer: \(Catalog.money(offer.cash)). It is handed off in person.") }
        let seller = db.seats.first { $0.id == listing.sellerId }
        let buyer = db.seats.first { $0.id == offer.buyerId }
        return Agreement(
            id: UUID().uuidString, offerId: offer.id, listingId: listing.id, tableId: listing.tableId,
            buyerId: offer.buyerId, sellerId: listing.sellerId, status: "awaiting_signatures",
            conditions: conditions.joined(separator: "\n"),
            signatures: [
                DealSignature(playerId: offer.buyerId, playerName: buyer?.displayName ?? offer.buyerName, role: "buyer", signedAt: nil, paidAt: nil),
                DealSignature(playerId: listing.sellerId, playerName: seller?.displayName ?? listing.sellerName, role: "seller", signedAt: nil, paidAt: nil),
            ],
            createdAt: Date(), completedAt: nil
        )
    }

    private func voidDeals(listingId: String) {
        for index in db.offers.indices where db.offers[index].listingId == listingId && db.offers[index].status == "pending" {
            db.offers[index].status = "rejected"
        }
        for index in db.agreements.indices where db.agreements[index].listingId == listingId && (db.agreements[index].status == "awaiting_signatures" || db.agreements[index].status == "awaiting_payment") {
            db.agreements[index].status = "declined"
        }
    }

    private func postSystem(_ text: String) {
        guard let me else { return }
        db.messages.append(ChatMessage(
            id: UUID().uuidString, tableId: me.tableId, senderId: nil, senderName: "Table",
            recipientId: nil, body: text, kind: "system", createdAt: Date()
        ))
    }

    private func hash(_ password: String) -> String {
        let salt = UUID().uuidString
        let digest = SHA256.hash(data: Data("\(salt):\(password)".utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        return "\(salt):\(hex)"
    }

    private func verify(_ password: String, hash stored: String) -> Bool {
        let parts = stored.split(separator: ":", maxSplits: 1).map(String.init)
        guard parts.count == 2 else { return false }
        let digest = SHA256.hash(data: Data("\(parts[0]):\(password)".utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        return hex == parts[1]
    }

    private var fileURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let folder = base.appendingPathComponent("MonopolyContract", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder.appendingPathComponent("table.json")
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let saved = try? decoder.decode(Database.self, from: data) { db = saved }
    }

    private func save() {
        if let token = accountToken { UserDefaults.standard.set(token, forKey: accountKey) }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(db) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}

private extension String {
    var fold: String { folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current) }
}

@main
struct MonopolyContractApp: App {
    @State private var store = GameStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}

struct RootView: View {
    @Environment(GameStore.self) private var store

    var body: some View {
        PaperScreen {
            Group {
                if store.playing, store.me != nil {
                    ShellView()
                } else {
                    GateView()
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let banner = store.banner {
                Text(banner)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.ink)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 28)
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(2.4))
                            store.banner = nil
                        }
                    }
            }
        }
    }
}

struct GateView: View {
    @Environment(GameStore.self) private var store
    @State private var username = ""
    @State private var password = ""
    @State private var startCode = ""
    @State private var joinCode = ""
    @State private var joinName = ""
    @State private var joinColor = "red"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("MONOPOLY CONTRACT")
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.gold)
                Text("Monopoly Contract")
                    .font(.largeTitle.bold())
                Text("Make an account or play for fun.")
                    .foregroundStyle(Color.muted)

                if let account = store.account {
                    CardBox {
                        Text("Signed in as \(account.username)")
                        Button("Sign out", action: store.signOutAccount)
                            .buttonStyle(GhostButton())
                    }
                } else {
                    CardBox {
                        FieldLabel(title: "Username")
                        TextField("Name", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                        FieldLabel(title: "Password")
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                        Button("Create account") { run { try store.register(username: username, password: password) } }
                            .buttonStyle(GreenButton())
                        Button("Sign in") { run { try store.login(username: username, password: password) } }
                            .buttonStyle(GhostButton())
                    }
                }

                if store.me != nil {
                    Button("Continue \(store.me?.displayName ?? "")") { store.continuePlaying() }
                        .buttonStyle(GreenButton())
                }

                CardBox {
                    Text("Start a table").font(.title3.bold())
                    FieldLabel(title: "Code")
                    TextField("CODE", text: $startCode)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.characters)
                        .onChange(of: startCode) { _, value in
                            startCode = String(value.uppercased().prefix(4))
                        }
                    Text("4 letters or numbers. Leave it blank for a random one.")
                        .font(.footnote)
                        .foregroundStyle(Color.muted)
                    Button("Create table") { run { try store.createTable(code: startCode) } }
                        .buttonStyle(GreenButton())
                }

                CardBox {
                    Text("Join a table").font(.title3.bold())
                    FieldLabel(title: "Code")
                    TextField("CODE", text: $joinCode)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.characters)
                        .onChange(of: joinCode) { _, value in
                            joinCode = String(value.uppercased().prefix(4))
                        }
                    Text(store.preview(code: joinCode))
                        .font(.footnote)
                        .foregroundStyle(Color.muted)
                    FieldLabel(title: "Name")
                    TextField(store.account?.username ?? "Player", text: $joinName)
                        .textFieldStyle(.roundedBorder)
                    FieldLabel(title: "Color")
                    colorChoices
                    Button("Join table") {
                        let name = joinName.isEmpty ? (store.account?.username ?? "") : joinName
                        run { try store.join(code: joinCode, name: name, color: joinColor) }
                    }
                    .buttonStyle(GreenButton())
                }
            }
            .padding(20)
        }
        .onAppear {
            if joinName.isEmpty, let username = store.account?.username { joinName = username }
        }
    }

    private var colorChoices: some View {
        let taken = store.takenColors(code: joinCode)
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 88), spacing: 8)], spacing: 8) {
            ForEach(Catalog.playerColors, id: \.name) { color in
                let used = taken.contains(color.name)
                Button(color.name.capitalized) { joinColor = color.name }
                    .font(.caption.weight(.semibold))
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: color.hex).opacity(joinColor == color.name ? 1 : 0.25))
                    .foregroundStyle(joinColor == color.name ? Color.white : Color.ink)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .disabled(used)
                    .opacity(used ? 0.35 : 1)
            }
        }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case market = "Marketplace"
    case contracts = "Contracts"
    case mine = "My Contract"
    case receiving = "Receiving contract"
    case agreement = "Contract agreement"
    case chat = "Chat"
    var id: String { rawValue }
}

struct ShellView: View {
    @Environment(GameStore.self) private var store
    @State private var tab: AppTab = .market
    @State private var confirmLeave = false
    @State private var showPhone = false
    @State private var showAdd = false
    @State private var askedEnd = ""
    @State private var askedStay = ""

    var body: some View {
        VStack(spacing: 0) {
            top
            Group {
                switch tab {
                case .market: MarketView()
                case .contracts: ContractsPickView()
                case .mine: MyContractView()
                case .receiving: ReceivingView()
                case .agreement: AgreementView()
                case .chat: ChatView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            tabBar
        }
        .confirmationDialog("Are you sure you want to leave?", isPresented: $confirmLeave, titleVisibility: .visible) {
            Button("Leave game", role: .destructive) { store.leave() }
            Button("Stay", role: .cancel) {}
        }
        .sheet(isPresented: $showPhone) { phoneSheet }
        .sheet(isPresented: $showAdd) { AddPlayerSheet() }
        .sheet(isPresented: endPresented) { endSheet }
        .sheet(isPresented: stayPresented) { staySheet }
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                store.tick()
            }
        }
        .onChange(of: tab) { _, newValue in
            if newValue == .receiving { store.markReceivingSeen() }
        }
    }

    private var top: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("MONOPOLY CONTRACT")
                        .font(.caption2.weight(.bold))
                        .tracking(1)
                        .foregroundStyle(Color.gold)
                    Text(store.table?.code ?? "")
                        .font(.title2.bold())
                }
                Spacer()
                Button("This phone") { showPhone = true }
                    .font(.caption.weight(.semibold))
                Button("Leave game") { confirmLeave = true }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.danger)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.seated) { seat in
                        HStack(spacing: 6) {
                            PlayerDot(color: seat.color)
                            Text(seat.displayName).font(.subheadline.weight(.semibold))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(Color.paper)
    }

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { item in
                Button {
                    tab = item
                } label: {
                    VStack(spacing: 2) {
                        Text(item.rawValue)
                            .font(.system(size: 10, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        if badge(item) {
                            Text("!")
                                .font(.caption.bold())
                                .foregroundStyle(Color(hex: "#c62828"))
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .foregroundStyle(tab == item ? Color.pine : Color.muted)
                    .background(tab == item ? Color(hex: "#e7f3ee") : Color.clear)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color.card)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.line), alignment: .top)
    }

    private func badge(_ item: AppTab) -> Bool {
        switch item {
        case .receiving: return store.incomingAlert
        case .chat: return store.chatAlert
        default: return false
        }
    }

    private var endPresented: Binding<Bool> {
        Binding(
            get: {
                guard let contract = store.incomingExterminate() else { return false }
                let mark = "\(contract.id):\(contract.endRequestedAt?.timeIntervalSince1970 ?? 0)"
                return askedEnd != mark
            },
            set: { showing in
                if !showing, let contract = store.incomingExterminate() {
                    askedEnd = "\(contract.id):\(contract.endRequestedAt?.timeIntervalSince1970 ?? 0)"
                }
            }
        )
    }

    private var stayPresented: Binding<Bool> {
        Binding(
            get: {
                guard let contract = store.stayContract() else { return false }
                return askedStay != contract.id
            },
            set: { showing in
                if !showing, let contract = store.stayContract() {
                    askedStay = contract.id
                    store.clearStay(contract.id)
                }
            }
        )
    }

    private var endSheet: some View {
        ConfirmSheet(
            title: "Are you sure you want to exterminate this contract?",
            words: store.incomingExterminate()?.body ?? "",
            yes: "Exterminate",
            destructive: true
        ) {
            guard let id = store.incomingExterminate()?.id else { return }
            switch try store.exterminate(id: id) {
            case .removed: store.banner = "Contract exterminated."
            case .expired: store.banner = "That request ran out."
            case .waiting: store.banner = "Waiting for the other player."
            }
        }
    }

    private var staySheet: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("The contract stays.").font(.title2.bold())
            Text(store.stayContract()?.body ?? "")
            Button("Close") { askedStay = store.stayContract()?.id ?? askedStay; if let id = store.stayContract()?.id { store.clearStay(id) } }
                .buttonStyle(GreenButton())
        }
        .padding(20)
        .presentationDetents([.medium])
    }

    private var phoneSheet: some View {
        NavigationStack {
            List {
                Section("Who is holding this phone") {
                    ForEach(store.seated) { seat in
                        Button {
                            store.useSeat(seat.id)
                            showPhone = false
                        } label: {
                            HStack {
                                PlayerDot(color: seat.color)
                                Text(seat.displayName)
                                if seat.id == store.me?.id { Text("Now").foregroundStyle(Color.muted) }
                            }
                        }
                    }
                }
                Button("Add a player on this phone") {
                    showPhone = false
                    showAdd = true
                }
            }
            .navigationTitle("This phone")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { showPhone = false } } }
        }
    }
}

struct AddPlayerSheet: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var color = "blue"

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("They stay at the table. Use This phone to hand it over.")
                    .foregroundStyle(Color.muted)
                TextField("Name", text: $name).textFieldStyle(.roundedBorder)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 88))], spacing: 8) {
                    ForEach(Catalog.playerColors, id: \.name) { item in
                        let taken = store.seated.contains { $0.color == item.name }
                        Button(item.name.capitalized) { color = item.name }
                            .font(.caption.weight(.semibold))
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: item.hex).opacity(color == item.name ? 1 : 0.25))
                            .foregroundStyle(color == item.name ? Color.white : Color.ink)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .disabled(taken)
                    }
                }
                Button("Add player") {
                    do {
                        try store.addPlayer(name: name, color: color)
                        dismiss()
                    } catch {
                        store.banner = error.localizedDescription
                    }
                }
                .buttonStyle(GreenButton())
                Spacer()
            }
            .padding(20)
            .navigationTitle("Add player")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }
}

struct ConfirmSheet: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
    var words: String
    var yes: String
    var destructive = false
    var action: () throws -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.title3.bold())
            Text(words)
            HStack {
                Button("Keep") { dismiss() }.buttonStyle(GhostButton())
                Button(yes) {
                    do { try action(); dismiss() } catch { }
                }
                .buttonStyle(GreenButton())
            }
        }
        .padding(20)
        .presentationDetents([.medium])
    }
}

struct MarketView: View {
    @Environment(GameStore.self) private var store
    @State private var showPut = false
    @State private var detailId: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Monopoly Contract").font(.largeTitle.bold())
                Button("Put on the Table") { showPut = true }
                    .buttonStyle(GreenButton())
                if store.visibleListings().isEmpty {
                    Text("Nothing on the table yet.")
                        .foregroundStyle(Color.muted)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                }
                ForEach(store.visibleListings()) { listing in
                    Button { detailId = listing.id } label: {
                        ListingCard(listing: listing)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .sheet(isPresented: $showPut) { PutOnTableView() }
        .sheet(isPresented: detailPresented) {
            if let detailId { ListingDetailView(listingId: detailId) }
        }
    }

    private var detailPresented: Binding<Bool> {
        Binding(get: { detailId != nil }, set: { if !$0 { detailId = nil } })
    }
}

struct ListingCard: View {
    @Environment(GameStore.self) private var store
    var listing: Listing

    var body: some View {
        CardBox {
            if listing.propertyIds.isEmpty {
                HStack {
                    Text(store.listingTitle(listing)).font(.headline)
                    if store.sellerAlert(listing) { Text("!").foregroundStyle(Color(hex: "#c62828")).font(.headline.bold()) }
                }
            } else {
                ForEach(listing.propertyIds, id: \.self) { id in
                    if let property = Catalog.property(id) {
                        HStack {
                            ColorBar(hex: property.colorHex)
                            Text(property.name).font(.headline)
                            if store.sellerAlert(listing) { Text("!").foregroundStyle(Color(hex: "#c62828")).bold() }
                        }
                    }
                }
            }
            HStack {
                PlayerDot(color: listing.sellerColor)
                Text(listing.sellerName)
            }
            Text(summary).foregroundStyle(Color.muted)
        }
    }

    private var summary: String {
        var bits: [String] = []
        if let price = listing.askingPrice { bits.append(Catalog.money(price)) }
        let math = Catalog.loanMath(amount: listing.loanAmount ?? listing.askingPrice, interest: listing.interest)
        if !math.isEmpty { bits.append(math) }
        if !listing.wanted.isEmpty { bits.append(listing.wanted) }
        if !listing.details.isEmpty { bits.append(listing.details) }
        return bits.joined(separator: " · ")
    }
}

struct PutOnTableView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var kind = "property"
    @State private var picked: Set<String> = []
    @State private var price = ""
    @State private var amount = ""
    @State private var interest = ""
    @State private var details = ""
    @State private var wanted = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Offer a property or a cash loan.")
                        .foregroundStyle(Color.muted)
                    HStack {
                        kindButton("property", "Property")
                        kindButton("loan", "Cash loan")
                    }
                    if kind == "property" {
                        ForEach(store.listableProperties()) { property in
                            Button {
                                if picked.contains(property.id) { picked.remove(property.id) } else { picked.insert(property.id) }
                            } label: {
                                HStack {
                                    Image(systemName: picked.contains(property.id) ? "checkmark.square.fill" : "square")
                                    ColorBar(hex: property.colorHex)
                                    Text(property.name)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        if store.listableProperties().isEmpty {
                            Text("No property is free to list.").foregroundStyle(Color.muted)
                        }
                        FieldLabel(title: "Asking price")
                        TextField("2500", text: $price).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
                        FieldLabel(title: "Special conditions")
                        TextField("Special conditions", text: $details, axis: .vertical).textFieldStyle(.roundedBorder)
                    } else {
                        FieldLabel(title: "Amount")
                        TextField("500", text: $amount).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
                        FieldLabel(title: "Interest %")
                        TextField("10", text: $interest).textFieldStyle(.roundedBorder).keyboardType(.decimalPad)
                        Text("Total").font(.subheadline.weight(.semibold))
                        Text(totalLine).font(.title3.bold())
                    }
                    FieldLabel(title: "What you want in exchange")
                    TextField("Example: Park Place, or nothing if this is a loan", text: $wanted, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    Button("Publish listing") { publish() }
                        .buttonStyle(GreenButton())
                }
                .padding(20)
            }
            .navigationTitle("Put on the Table")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }

    private var totalLine: String {
        let line = Catalog.loanMath(amount: Int(amount), interest: interest)
        return line.isEmpty ? "Total shows after the amount and interest." : line
    }

    private func kindButton(_ id: String, _ title: String) -> some View {
        Button(title) { kind = id }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(kind == id ? Color.pine : Color.card)
            .foregroundStyle(kind == id ? Color.white : Color.ink)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.line, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .buttonStyle(.plain)
    }

    private func publish() {
        do {
            let math = Catalog.loanMath(amount: Int(amount), interest: interest)
            try store.createListing(
                kind: kind,
                propertyIds: Array(picked),
                askingPrice: Int(price),
                loanAmount: Int(amount),
                interest: kind == "loan" ? (interest.isEmpty ? "" : "\(interest)%") : "",
                details: kind == "loan" ? math : details,
                wanted: wanted
            )
            dismiss()
            store.banner = "It is on the table."
        } catch {
            store.banner = error.localizedDescription
        }
    }
}

struct ListingDetailView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    var listingId: String
    @State private var editing = false
    @State private var countering = false

    private var listing: Listing? { store.db.listings.first { $0.id == listingId } }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let listing {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(store.listingTitle(listing)).font(.title2.bold())
                            if store.sellerAlert(listing) {
                                Text("!").font(.title2.bold()).foregroundStyle(Color(hex: "#c62828"))
                            }
                        }
                        Text(statusText(listing))
                        if let math = loanLine(listing), !math.isEmpty {
                            Text(math).font(.title3.bold())
                        } else if let price = listing.askingPrice {
                            Text(Catalog.money(price)).font(.title3.bold())
                        }
                        if !listing.interest.isEmpty && loanLine(listing)?.isEmpty != false {
                            Text("Interest: \(listing.interest)")
                        }
                        Text("From: \(listing.sellerName)")
                        if !listing.wanted.isEmpty { Text("Wants: \(listing.wanted)") }
                        if !listing.details.isEmpty && listing.details != loanLine(listing) { Text(listing.details) }
                        if let deal = store.agreement(for: listing.id) { dealBox(deal) }
                        let openOffers = store.offers(for: listing.id)
                        if !openOffers.isEmpty {
                            Text("Offers").font(.headline)
                            ForEach(openOffers) { offer in offerRow(listing, offer) }
                        }
                        if listing.sellerId != store.me?.id && listing.status == "active" && !openOffers.contains(where: { $0.status == "pending" && $0.buyerId == store.me?.id }) {
                            Button(listing.offerKind == "property" ? "Accept" : "Accept terms") {
                                run { try store.acceptTerms(listingId: listing.id) }
                            }
                            .buttonStyle(GreenButton())
                            if listing.offerKind == "property" {
                                Button("Counter") { countering = true }.buttonStyle(GhostButton())
                            }
                            Button("Decline") {
                                store.passListing(id: listing.id)
                                dismiss()
                            }
                            .buttonStyle(GhostButton(tint: Color.danger))
                        }
                        if listing.sellerId == store.me?.id && listing.status != "sold" {
                            Button("Take off the table") { run { try store.withdrawListing(id: listing.id); dismiss() } }
                                .buttonStyle(GhostButton())
                            Button("Edit listing") { editing = true }.buttonStyle(GhostButton())
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("On the table")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
        .sheet(isPresented: $editing) {
            if let listing { EditListingSheet(listing: listing) }
        }
        .sheet(isPresented: $countering) {
            if let listing { CounterOfferSheet(listing: listing) }
        }
    }

    private func loanLine(_ listing: Listing) -> String? {
        guard listing.offerKind == "loan" else { return nil }
        return Catalog.loanMath(amount: listing.loanAmount ?? listing.askingPrice, interest: listing.interest)
    }

    private func statusText(_ listing: Listing) -> String {
        switch listing.status {
        case "pending_sale": return "Accepted, waiting for signatures"
        case "pending_approval": return "Waiting for the other owners"
        default: return "On the table"
        }
    }

    private func dealBox(_ deal: Agreement) -> some View {
        CardBox {
            Text("Deal sheet").font(.headline)
            Text(deal.conditions)
            ForEach(deal.signatures) { sig in
                Text("\(sig.playerName) (\(sig.role)): \(sig.signedAt == nil ? "Not signed" : "Signed")\(sig.paidAt == nil ? "" : ", paid")")
            }
            if deal.signatures.contains(where: { $0.playerId == store.me?.id && $0.signedAt == nil }) {
                Button("Sign") { run { try store.sign(agreementId: deal.id) } }.buttonStyle(GreenButton())
            }
            if deal.status == "awaiting_payment" && deal.signatures.contains(where: { $0.playerId == store.me?.id && $0.paidAt == nil }) {
                Button("Confirm handoff") { run { try store.confirmHandoff(agreementId: deal.id) } }.buttonStyle(GreenButton())
            }
            if deal.status != "completed" {
                Button("Decline") { run { try store.declineDeal(agreementId: deal.id) } }.buttonStyle(GhostButton(tint: Color.danger))
            }
        }
    }

    private func offerRow(_ listing: Listing, _ offer: Offer) -> some View {
        CardBox {
            Text("\(offer.fromName) · \(offer.status)").font(.headline)
            Text(offerBits(offer))
            if listing.sellerId == store.me?.id && offer.status == "pending" {
                Button("Accept") { run { try store.acceptOffer(id: offer.id) } }.buttonStyle(GreenButton())
            }
            if offer.fromId == store.me?.id && offer.status == "pending" {
                Button("Take off") { run { try store.rejectOffer(id: offer.id) } }.buttonStyle(GhostButton())
            }
        }
    }

    private func offerBits(_ offer: Offer) -> String {
        var bits: [String] = []
        if offer.cash > 0 { bits.append(Catalog.money(offer.cash)) }
        bits.append(contentsOf: offer.propertyIds.compactMap { Catalog.property($0)?.name })
        if offer.equityPercent > 0 { bits.append("\(offer.equityPercent)% equity kept by seller") }
        if !offer.customTerms.isEmpty { bits.append(offer.customTerms) }
        return bits.isEmpty ? "Custom deal" : bits.joined(separator: ", ")
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

struct EditListingSheet: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    var listing: Listing
    @State private var price = ""
    @State private var details = ""
    @State private var wanted = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Changing this listing cancels an accepted deal and asks everyone to approve the new terms.")
                    .foregroundStyle(Color.muted)
                FieldLabel(title: listing.offerKind == "property" ? "Asking price" : "Amount")
                TextField("Price", text: $price).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
                FieldLabel(title: "Special conditions")
                TextField("Special conditions", text: $details, axis: .vertical).textFieldStyle(.roundedBorder)
                FieldLabel(title: "What you want")
                TextField("What you want", text: $wanted, axis: .vertical).textFieldStyle(.roundedBorder)
                Button("Save listing") {
                    run {
                        try store.updateListing(id: listing.id, price: Int(price), details: details, wanted: wanted)
                        dismiss()
                    }
                }
                .buttonStyle(GreenButton())
                Spacer()
            }
            .padding(20)
            .navigationTitle("Edit listing")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            .onAppear {
                if let asking = listing.askingPrice { price = String(asking) }
                details = listing.details
                wanted = listing.wanted
            }
        }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

struct CounterOfferSheet: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    var listing: Listing
    @State private var cash = ""
    @State private var equity = ""
    @State private var terms = ""
    @State private var picked: Set<String> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Cash, deeds, equity the seller keeps, or a custom mix. The seller must accept before anything moves.")
                        .foregroundStyle(Color.muted)
                    FieldLabel(title: "Cash")
                    TextField("0", text: $cash).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
                    Text("Your properties").font(.subheadline.weight(.semibold))
                    let mine = Catalog.properties.filter { id in
                        store.db.ownership.contains { $0.propertyId == id.id && $0.ownerId == store.me?.id && $0.tableId == store.me?.tableId }
                            && !listing.propertyIds.contains(id.id)
                    }
                    if mine.isEmpty { Text("You have no other deeds to offer.").foregroundStyle(Color.muted) }
                    ForEach(mine) { property in
                        Button {
                            if picked.contains(property.id) { picked.remove(property.id) } else { picked.insert(property.id) }
                        } label: {
                            HStack {
                                Image(systemName: picked.contains(property.id) ? "checkmark.square.fill" : "square")
                                Text(property.name)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    FieldLabel(title: "Percent of this property the seller keeps")
                    TextField("0", text: $equity).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
                    FieldLabel(title: "Custom terms")
                    TextField("Terms", text: $terms, axis: .vertical).textFieldStyle(.roundedBorder)
                    Button("Submit offer") {
                        run {
                            try store.makeOffer(
                                listingId: listing.id,
                                cash: Int(cash) ?? 0,
                                propertyIds: Array(picked),
                                equity: Int(equity) ?? 0,
                                terms: terms
                            )
                            dismiss()
                        }
                    }
                    .buttonStyle(GreenButton())
                }
                .padding(20)
            }
            .navigationTitle("Counter")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

struct ContractsPickView: View {
    @Environment(GameStore.self) private var store
    @State private var picked: Set<String> = []
    @State private var playerId = ""
    @State private var showNote = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Contracts").font(.largeTitle.bold())
                Text("Tap every property in the deal. Tap one again to take it off. Then tap a player. Tap that player again to take them off.")
                    .foregroundStyle(Color.muted)
                ForEach(Catalog.properties) { property in
                    Button {
                        if picked.contains(property.id) { picked.remove(property.id) } else { picked.insert(property.id) }
                    } label: {
                        HStack {
                            ColorBar(hex: property.colorHex)
                            Text(property.name).font(.headline)
                            Spacer()
                            if picked.contains(property.id) { Image(systemName: "checkmark") }
                        }
                        .padding(10)
                        .background(picked.contains(property.id) ? Color(hex: "#e7f3ee") : Color.card)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.line, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
                Text("Players").font(.title3.bold())
                let others = store.seated.filter { $0.id != store.me?.id }
                if others.isEmpty {
                    Text("Waiting for another player.").foregroundStyle(Color.muted)
                }
                ForEach(others) { seat in
                    Button {
                        playerId = playerId == seat.id ? "" : seat.id
                    } label: {
                        HStack {
                            PlayerDot(color: seat.color)
                            Text(seat.displayName).font(.headline)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(playerId == seat.id ? Color.pine : Color.card)
                        .foregroundStyle(playerId == seat.id ? Color.white : Color.ink)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                if !picked.isEmpty && !playerId.isEmpty {
                    Button("Write the contract") { showNote = true }
                        .buttonStyle(GreenButton())
                }
            }
            .padding(16)
        }
        .sheet(isPresented: $showNote) {
            ContractNoteSheet(propertyIds: Array(picked), recipientId: playerId, draft: "", priorId: nil, queuedAllowed: true)
        }
    }
}

struct MyContractView: View {
    @Environment(GameStore.self) private var store
    @State private var reopen: DealContract?
    @State private var unsend: DealContract?

    private var mine: [DealContract] {
        store.visibleContracts().filter { $0.obligorId == store.me?.id && !$0.accepted }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("My Contract").font(.largeTitle.bold())
                Text("Queued drafts and sent contracts stay here until the other player accepts.")
                    .foregroundStyle(Color.muted)
                if mine.isEmpty { Text("Nothing saved yet.").foregroundStyle(Color.muted).frame(maxWidth: .infinity).padding(.top, 20) }
                ForEach(mine.filter(\.queued)) { contract in
                    Button { reopen = contract } label: { contractCard(contract, sent: false) }
                        .buttonStyle(.plain)
                }
                ForEach(mine.filter { !$0.queued }) { contract in
                    VStack(alignment: .leading, spacing: 8) {
                        contractCard(contract, sent: true)
                        Button("Unsend") { unsend = contract }
                            .buttonStyle(GhostButton(tint: Color.danger))
                    }
                }
            }
            .padding(16)
        }
        .sheet(item: $reopen) { contract in
            ContractNoteSheet(
                propertyIds: contract.propertyIds,
                recipientId: contract.recipientId ?? "",
                draft: contract.body,
                priorId: nil,
                queuedAllowed: false,
                existingId: contract.id
            )
        }
        .confirmationDialog("Are you sure you want to unsend this contract?", isPresented: unsendPresented, titleVisibility: .visible) {
            Button("Unsend", role: .destructive) {
                if let id = unsend?.id { run { try store.unsendContract(id: id) }; store.banner = "Contract unsent." }
            }
            Button("Keep", role: .cancel) {}
        }
    }

    private var unsendPresented: Binding<Bool> {
        Binding(get: { unsend != nil }, set: { if !$0 { unsend = nil } })
    }

    private func contractCard(_ contract: DealContract, sent: Bool) -> some View {
        CardBox {
            ForEach(contract.propertyIds, id: \.self) { id in
                if let property = Catalog.property(id) {
                    HStack { ColorBar(hex: property.colorHex); Text(property.name).bold() }
                }
            }
            Text(sent ? "Sent to \(contract.recipientName ?? "the other player")" : (contract.recipientName ?? "Player"))
            Text(contract.body.isEmpty ? "No note yet." : contract.body)
        }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

struct ReceivingView: View {
    @Environment(GameStore.self) private var store
    @State private var counter: DealContract?

    private var incoming: [DealContract] {
        store.visibleContracts().filter { !$0.accepted && !$0.queued && $0.recipientId == store.me?.id }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Receiving contract").font(.largeTitle.bold())
                Text("Only offers sent to you show up here.").foregroundStyle(Color.muted)
                if incoming.isEmpty { Text("No offers yet.").foregroundStyle(Color.muted).frame(maxWidth: .infinity).padding(.top, 20) }
                ForEach(incoming) { contract in
                    CardBox {
                        ForEach(contract.propertyIds, id: \.self) { id in
                            if let property = Catalog.property(id) {
                                HStack { ColorBar(hex: property.colorHex); Text(property.name).bold() }
                            }
                        }
                        Text("From \(contract.obligorName)")
                        Text(contract.body)
                        HStack {
                            Button("Accept") {
                                run { try store.acceptContract(id: contract.id) }
                                store.banner = "Offer accepted."
                            }
                            .buttonStyle(GreenButton())
                            Button("Deny") { run { try store.denyContract(id: contract.id) }; store.banner = "Offer denied." }
                                .buttonStyle(GhostButton(tint: Color.danger))
                            Button("Counter") { counter = contract }
                                .buttonStyle(GhostButton())
                        }
                    }
                }
            }
            .padding(16)
        }
        .onAppear { store.markReceivingSeen() }
        .sheet(item: $counter) { contract in
            ContractNoteSheet(
                propertyIds: contract.propertyIds,
                recipientId: contract.obligorId,
                draft: contract.body,
                priorId: contract.id,
                queuedAllowed: false
            )
        }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

struct AgreementView: View {
    @Environment(GameStore.self) private var store
    @State private var ending: DealContract?

    private var accepted: [DealContract] {
        store.visibleContracts().filter { $0.accepted && ($0.obligorId == store.me?.id || $0.recipientId == store.me?.id) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Contract agreement").font(.largeTitle.bold())
                if accepted.isEmpty { Text("No agreements yet.").foregroundStyle(Color.muted).frame(maxWidth: .infinity).padding(.top, 20) }
                ForEach(accepted) { contract in
                    CardBox {
                        ForEach(contract.propertyIds, id: \.self) { id in
                            if let property = Catalog.property(id) {
                                HStack { ColorBar(hex: property.colorHex); Text(property.name).bold() }
                            }
                        }
                        Text("\(contract.obligorName) and \(contract.recipientName ?? "the other player")")
                        Text(contract.body)
                        if store.otherEnd(contract) && !store.myEnd(contract) {
                            Text("The other player wants to exterminate this contract.")
                        }
                        if store.myEnd(contract) {
                            Text("Waiting for the other player.")
                        } else {
                            Button("Exterminate contract") { ending = contract }
                                .buttonStyle(GhostButton(tint: Color.danger))
                        }
                    }
                }
            }
            .padding(16)
        }
        .confirmationDialog("Are you sure you want to exterminate this contract?", isPresented: endPresented, titleVisibility: .visible) {
            Button("Exterminate", role: .destructive) {
                guard let id = ending?.id else { return }
                do {
                    switch try store.exterminate(id: id) {
                    case .removed: store.banner = "Contract exterminated."
                    case .expired: store.banner = "That request ran out."
                    case .waiting: store.banner = "Waiting for the other player."
                    }
                } catch { store.banner = error.localizedDescription }
            }
            Button("Keep", role: .cancel) {}
        } message: {
            Text(ending?.body ?? "")
        }
    }

    private var endPresented: Binding<Bool> {
        Binding(get: { ending != nil }, set: { if !$0 { ending = nil } })
    }
}

struct ContractNoteSheet: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    var propertyIds: [String]
    var recipientId: String
    var draft: String
    var priorId: String?
    var queuedAllowed: Bool
    var existingId: String? = nil
    @State private var note = ""
    @State private var editing: QuickNote?
    @State private var editText = ""
    @State private var deleting: QuickNote?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(propertyIds, id: \.self) { id in
                        if let property = Catalog.property(id) {
                            HStack { ColorBar(hex: property.colorHex); Text(property.name).font(.title3.bold()) }
                        }
                    }
                    if let name = store.db.seats.first(where: { $0.id == recipientId })?.displayName {
                        Text(name).foregroundStyle(Color.muted)
                    }
                    TextField("Contract note", text: $note, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(4...10)
                    if store.account != nil {
                        Text("Quick notes").font(.headline)
                        if store.account?.notes.isEmpty != false {
                            Text("Save a note by sending a short contract while signed in.").font(.footnote).foregroundStyle(Color.muted)
                        }
                        ForEach(store.account?.notes ?? []) { item in
                            HStack {
                                Button(item.body) {
                                    let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
                                    note = trimmed.isEmpty ? item.body : trimmed + "\n" + item.body
                                }
                                .buttonStyle(.plain)
                                Spacer()
                                Button("Edit") { editing = item; editText = item.body }.font(.caption)
                                Button("Delete") { deleting = item }.font(.caption).foregroundStyle(Color.danger)
                            }
                        }
                        if let editing {
                            TextField("Quick note", text: $editText).textFieldStyle(.roundedBorder)
                            Button("Save") {
                                run { try store.updateNote(id: editing.id, body: editText) }
                                self.editing = nil
                            }
                            .buttonStyle(GreenButton())
                        }
                    }
                    Button("Sent contract") { save(queued: false) }.buttonStyle(GreenButton())
                    if queuedAllowed {
                        Button("Queue") { save(queued: true) }.buttonStyle(GhostButton())
                    }
                }
                .padding(20)
            }
            .navigationTitle(priorId == nil ? "Contract" : "Counter")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            .onAppear { note = draft }
            .confirmationDialog("Are you sure you want to delete this quick note?", isPresented: deletePresented, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let id = deleting?.id { run { try store.deleteNote(id: id) } }
                }
                Button("Keep", role: .cancel) {}
            }
        }
    }

    private var deletePresented: Binding<Bool> {
        Binding(get: { deleting != nil }, set: { if !$0 { deleting = nil } })
    }

    private func save(queued: Bool) {
        run {
            if let existingId, queuedAllowed == false, priorId == nil {
                try store.unsendContract(id: existingId)
            }
            try store.sendContract(propertyIds: propertyIds, recipientId: recipientId, body: note, queued: queued, priorId: priorId)
            dismiss()
            store.banner = queued ? "Saved in My Contract." : "Contract sent."
        }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

struct ChatView: View {
    @Environment(GameStore.self) private var store
    @State private var privateWith = ""
    @State private var draft = ""

    private var group: Bool { privateWith.isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Chat").font(.title2.bold())
                Spacer()
                Button("Group") {
                    privateWith = ""
                    store.markChat(group: true, playerId: nil)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(group ? Color.pine : Color.muted)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(store.seated.filter { $0.id != store.me?.id }) { seat in
                        Button(seat.displayName) {
                            privateWith = seat.id
                            store.markChat(group: false, playerId: seat.id)
                        }
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(privateWith == seat.id ? Color.pine : Color.card)
                        .foregroundStyle(privateWith == seat.id ? Color.white : Color.ink)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(store.messages(with: group ? nil : privateWith)) { message in
                        if message.kind == "system" {
                            Text(message.body).italic().foregroundStyle(Color.muted)
                        } else {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(message.senderName).font(.caption.weight(.semibold))
                                Text(message.body)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: message.senderId == store.me?.id ? .trailing : .leading)
                            .background(message.senderId == store.me?.id ? Color(hex: "#e5f4ee") : Color(hex: "#f3ecdf"))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding(16)
            }
            HStack {
                TextField(group ? "Message everyone" : "Private message", text: $draft)
                    .textFieldStyle(.roundedBorder)
                Button("Send") {
                    run {
                        try store.sendChat(body: draft, to: group ? nil : privateWith)
                        draft = ""
                        store.markChat(group: group, playerId: group ? nil : privateWith)
                    }
                }
                .buttonStyle(GreenButton())
                .frame(width: 110)
            }
            .padding(12)
        }
        .onAppear { store.markChat(group: true, playerId: nil) }
    }

    private func run(_ work: () throws -> Void) {
        do { try work() } catch { store.banner = error.localizedDescription }
    }
}

