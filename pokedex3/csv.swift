//
//  CSV
//  Modified by Mark Price on 08/14/15
//
import Foundation

open class CSV {
    open var headers: [String] = []
    open var rows: [Dictionary<String, String>] = []
    // ⚡ Optimization: Lazy evaluation of columns dictionary.
    // Computing columns eager-parses every row for every header (O(N*H) dictionary lookups).
    // Making it lazy avoids thousands of redundant allocations at startup when columns is not accessed.
    open lazy var columns: Dictionary<String, [String]> = self.parseColumns()
    var delimiter = CharacterSet(charactersIn: ",")
    
    public init(content: String?, delimiter: CharacterSet, encoding: UInt) throws{
        if let csvStringToParse = content{
            self.delimiter = delimiter
            
            let newline = CharacterSet.newlines
            var lines: [String] = []
            csvStringToParse.trimmingCharacters(in: newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
        }
    }
    
    public convenience init(contentsOfURL url: String) throws {
        let comma = CharacterSet(charactersIn: ",")
        let csvString: String?
        do {
            csvString = try String(contentsOfFile: url, encoding: String.Encoding.utf8)
        } catch _ {
            csvString = nil
        };
        try self.init(content: csvString,delimiter:comma, encoding:String.Encoding.utf8.rawValue)
    }
    
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].components(separatedBy: self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        guard lines.count > 1 else { return [] }

        // ⚡ Optimization: Pre-allocate capacity for rows and row dictionaries,
        // and iterate with dropFirst() and index loops to avoid repeated allocations
        // and header enumeration overhead for every line during app startup.
        var rows: [Dictionary<String, String>] = []
        rows.reserveCapacity(lines.count - 1)
        
        let headerCount = self.headers.count

        for line in lines.dropFirst() {
            var row = Dictionary<String, String>(minimumCapacity: headerCount)
            let values = line.components(separatedBy: self.delimiter)
            for index in 0..<headerCount {
                let header = self.headers[index]
                if index < values.count {
                    row[header] = values[index]
                } else {
                    row[header] = ""
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns() -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
}
