import Foundation
import Danger

// MARK: Helper methods

func validateTitleAllowsMerging(for pullRequest: GitHub.PullRequest) throws {
    let range = NSRange(pullRequest.title.startIndex..., in: pullRequest.title)

    let wipRegex = try NSRegularExpression(pattern: "\\bWIP\\b", options: .caseInsensitive)
    if wipRegex.firstMatch(in: pullRequest.title, range: range) != nil {
        print("Pull request title contains “WIP”.")
    }

    let doNotMergeRegex = try NSRegularExpression(pattern: "\\bdo not merge\\b", options: .caseInsensitive)
    if doNotMergeRegex.firstMatch(in: pullRequest.title, range: range) != nil {
        print("Pull request title contains “do not merge”.")
    }
}

func validateMessage(for ghCommit: GitHub.Commit, doesNotHavePrefixes prefixes: [String]) {
    let commitMessage = ghCommit.commit.message.lowercased()
    for prefix in prefixes where commitMessage.hasPrefix(prefix.lowercased()) {
        fail("Commit message \(ghCommit.sha) begins with `\(prefix)`. Squash before merging.")
    }
}

func validateSwiftLintRuleChanges(for git: Git) {
    let hasLintConfigChanges = git.modifiedFiles.contains(".swiftlint.yml")
    let hasCustomRuleChanges = git.modifiedFiles.contains("SwiftLint/customrules.yml")

    if hasLintConfigChanges, !hasCustomRuleChanges {
        warn("You updated the SwiftLint config. Do you also need to add a new rule to `customrules.yml`?")
    } else if !hasLintConfigChanges, hasCustomRuleChanges {
        warn("You added a new custom SwiftLint rule, don't forget to add it to DressCode's `.swiftlint.yml`!")
    }
}

func messageIsGenerated(for ghCommit: GitHub.Commit) -> Bool {
    guard let firstWord = ghCommit.commit.message.components(separatedBy: " ").first else {
        return false
    }
    return firstWord == "Merge" || firstWord == "Revert" || firstWord == "fixup!" || firstWord == "squash!"
}

/// Fails if the commit’s message does not satisfy Chris Beams’s
/// [“The seven rules of a great Git commit message”](https://chris.beams.io/posts/git-commit/).
func validateMessageIsGreat(for ghCommit: GitHub.Commit) {
    guard !messageIsGenerated(for: ghCommit) else { return }

    let messageComponents = ghCommit.commit.message.components(separatedBy: "\n")
    let title = messageComponents[0]

    // Rule 1
    if messageComponents.count > 1 {
        let separator = messageComponents[1]
        if !separator.isEmpty {
            fail("Commit message \(ghCommit.sha) is missing a blank line between title and body.")
        }
    }

    // Rule 2
    if title.count > 50 {
        fail("Commit title \(ghCommit.sha) is \(title.count) characters long (title should be limited to 50 characters).")
    }

    // Rule 3
    if title.first != title.capitalized.first {
        fail("Commit title \(ghCommit.sha) is not capitalized.")
    }

    // Rule 4
    if title.hasSuffix(".") {
        fail("Commit title \(ghCommit.sha) ends with a period.")
    }

    // Rule 5
    // Use the imperative mood in the subject line
    // Not validated here

    // Rule 6
    let body = messageComponents.dropFirst()
    let lineNumbers = body.indices.map({ $0 + 1 })
    for (lineNumber, line) in zip(lineNumbers, body) where line.count > 72 {
        fail("Commit message \(ghCommit.sha) line \(lineNumber) is \(line.count) characters long (body should be wrapped at 72 characters).")
    }

    // Rule 7
    // Use the body to explain what and why vs. how
    // Not validated here
}

// MARK: - Validations

let danger = Danger()
let pullRequest = danger.github.pullRequest

try validateTitleAllowsMerging(for: pullRequest)

validateSwiftLintRuleChanges(for: danger.git)

let unmergeablePrefixes = ["fixup!", "squash!", "WIP"]
danger.github.commits.forEach {
    validateMessage(for: $0, doesNotHavePrefixes: unmergeablePrefixes)
    validateMessageIsGreat(for: $0)
}

if let additions = pullRequest.additions, let deletions = pullRequest.deletions, additions < deletions {
    message("🎉 This PR removes more code than it adds! (\(additions - deletions) net lines)")
}

SwiftLint.lint(inline: true, configFile: ".swiftlint.yml")
