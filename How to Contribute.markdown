# How to contribute

Want to help out with the Swift Algorithm Club? Great!

## What sort of things can you contribute?

Take a look at the [list](README.markdown). Any algorithms or data structures that don't have a link yet are up for grabs.

Algorithms in the [Under construction](Under Construction.markdown) area are being worked on. Suggestions and feedback is welcome!

New algorithms and data structures are always welcome (even if they aren't on the list).

We're always interested in improvements to existing implementations and better explanations. Suggestions for making the code more Swift-like or to make it fit better with the standard library.

Unit tests. Fixes for typos. No contribution is too small. :-)

## Please follow this process

To keep this a high quality repo, please follow this process when submitting your contribution:

1. Create a pull request to "claim" an algorithm or data structure. Just so multiple people don't work on the same thing.
2. Use this [style guide](https://github.com/raywenderlich/swift-style-guide) for writing code (more or less).
3. Write an explanation of how the algorithm works. Include **plenty of examples** for readers to follow along. Pictures are good. Take a look at [the explanation of quicksort](Quicksort/) to get an idea.
4. Include your name in the explanation, something like *Written by Your Name* at the end of the document. If you wrote it, you deserve the credit and fame.
5. Add a playground and/or unit tests.
6. Run [SwiftLint](https://github.com/realm/SwiftLint)  
  - [Install](https://github.com/realm/SwiftLint#installation)
  - Open terminal and run the `swiftlint` command:

```
cd path/to/swift-algorithm-club
swiftlint
```


Just so you know, I will probably edit your text and code for grammar etc, just to ensure a certain level of polish.

For the unit tests:

- Add the unit test project to `.travis.yml` so they will be run on [Travis-CI](https://travis-ci.org/raywenderlich/swift-algorithm-club). Add a line to `.travis.yml` like this:

```
- xctool test -project ./Algorithm/Tests/Tests.xcodeproj -scheme Tests
```

- Configure the Test project's scheme to run on Travis-CI:
    - Open **Product -> Scheme -> Manage Schemes...**
    - Uncheck **Autocreate schemes**
    - Check **Shared**

![Screenshot of scheme settings](Images/scheme-settings-for-travis.png)

## Want to chat?

This isn't just a repo with a bunch of code... If you want to learn more about how an algorithm works or want to discuss better ways of solving problems, then open a [Github issue](https://github.com/raywenderlich/swift-algorithm-club/issues) and we'll talk!
