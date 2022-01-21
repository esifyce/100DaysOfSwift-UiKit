import Foundation

extension String {
    func withPrefix(_ prefix: String) -> String {
        return self + prefix
    }
}

var auto = "car"
print(auto.withPrefix("pet"))

extension String {
    func isNumeric() -> Bool {
        return Double(self) != nil
       
    }
}
var checkOnExistNumberIn = "12"
print(checkOnExistNumberIn.isNumeric())

extension String {
    func lines() -> [String] {
            return self.components(separatedBy: .newlines)
        }
}
var lines = "this\nis\na\ntest"
print(lines.lines())
