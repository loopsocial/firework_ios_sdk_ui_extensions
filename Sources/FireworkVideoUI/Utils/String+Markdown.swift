//
//  String+Markdown.swift
//  FireworkVideoUI
//
//  Created by linjie jiang on 11/19/24.
//

import Foundation

public extension String {
    func parseMarkdown() -> String {
        var resultMarkdownText = self
        // markdown unordered item
        resultMarkdownText = resultMarkdownText.replacingOccurrences(of: "\n- ", with: "\n&nbsp;&nbsp;• ")
        resultMarkdownText = resultMarkdownText.replacingOccurrences(of: "\n* ", with: "\n&nbsp;&nbsp;• ")
        // markdown ordered item
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "\n(\\d+?)\\. ",
            createReplaceContent: { content in
                "\n&nbsp;&nbsp;\(content). "
            }
        )
        // markdown strikethrough
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "~~(.+?)~~",
            createReplaceContent: { content in
                "<del>\(content)</del>"
            }
        )
        // markdown strong
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "\\*\\*(.+?)\\*\\*",
            createReplaceContent: { content in
                "<strong>\(content)</strong>"
            }
        )
        // markdown italic
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "\\*(.+)\\*",
            createReplaceContent: { content in
                "<em>\(content)</em>"
            }
        )
        // markdown h1
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "\n# (.+)(?=($|\n))",
            createReplaceContent: { content in
                "\n<h1>\(content)</h1>"
            }
        )
        // markdown h2
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "\n## (.+)(?=($|\n))",
            createReplaceContent: { content in
                "\n<h2>\(content)</h2>"
            }
        )
        // markdown h3
        resultMarkdownText = parse(
            resultMarkdownText,
            pattern: "\n### (.+?)(?=($|\n))",
            createReplaceContent: { content in
                "\n<h3>\(content)</h3>"
            }
        )
        resultMarkdownText = parseMarkdownLink(resultMarkdownText)
        resultMarkdownText = resultMarkdownText.replacingOccurrences(of: "\n", with: "<br />")
        return resultMarkdownText
    }

    private func parse(
        _ string: String,
        pattern: String,
        createReplaceContent: (String) -> String
    ) -> String {
        var result = string
        var searchRange = NSRange(location: 0, length: result.count)
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            while let match = regex.firstMatch(
                in: result,
                range: searchRange
            ), match.numberOfRanges > 1 {
                let matchRange = match.range
                let contentRange = match.range(at: 1)
                let content = (result as NSString).substring(with: contentRange)
                let replaceContent = createReplaceContent(content)
                result = (result as NSString).replacingCharacters(in: matchRange, with: replaceContent)
                let newSearchRangeLocation = matchRange.location + replaceContent.count
                if newSearchRangeLocation < result.count {
                    searchRange = NSRange(
                        location: newSearchRangeLocation,
                        length: result.count - newSearchRangeLocation
                    )
                } else {
                    break
                }
            }
        }

        return result
    }

    private func parseMarkdownLink(_ string: String) -> String {
        var result = string
        var searchRange = NSRange(location: 0, length: result.count)
        if let regex = try? NSRegularExpression(pattern: "\\[(.*?)\\]\\((.*?)\\)", options: []) {
            while let match = regex.firstMatch(
                in: result,
                range: searchRange
            ), match.numberOfRanges > 2 {
                let matchRange = match.range
                let linkNameRange = match.range(at: 1)
                let linkRange = match.range(at: 2)
                let linkName = (result as NSString).substring(with: linkNameRange)
                let link = (result as NSString).substring(with: linkRange)
                let replaceContent = "<a href=\"\(link)\">\(linkName)</a>"
                result = (result as NSString).replacingCharacters(in: matchRange, with: replaceContent)
                let newSearchRangeLocation = matchRange.location + replaceContent.count
                if newSearchRangeLocation < result.count {
                    searchRange = NSRange(
                        location: newSearchRangeLocation,
                        length: result.count - newSearchRangeLocation
                    )
                } else {
                    break
                }
            }
        }

        return result
    }
}
