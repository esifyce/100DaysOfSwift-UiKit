import UIKit

 // MARK: - index array in string

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

// MARK: - "remove suffix & prefix text"

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    // remove a prefix
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self}
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasPrefix(suffix) else { return self}
        return String(self.dropFirst(suffix.count))
    }
}

password.deletingPrefix("123")

// MARK: - Only first letter becomes capitalez

let weather = "It's going to rain"
print(weather.capitalized)

extension String {
    var capitalezFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalezFirst)



// MARK: - Check array with out string on contains word

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)
languages.contains(where: input.contains)


// MARK: - Formating string
let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString1 = NSMutableAttributedString(string: string)
attributedString1.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString1.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString1.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString1.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString1.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
