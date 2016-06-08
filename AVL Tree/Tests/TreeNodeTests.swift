//
//  TreeNodeTest.swift
//  AVLTreeTests
//
//  Created by Barbara Rodeker on 2/19/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest

class TreeNodeTests: XCTestCase {

    var root: TreeNode<String, String>?
    var left: TreeNode<String, String>?
    var right: TreeNode<String, String>?

    override func setUp() {
        super.setUp()

        left = TreeNode<String, String>(key: "Name", payload: "Left")
        right = TreeNode<String, String>(key: "Name", payload: "Right")
        root = TreeNode<String, String>(key: "Name", payload: "Root", leftChild: left, rightChild: right, parent: nil, height: 0)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testSingleNodeCreationNOPayload() {
        let treeNode = TreeNode<String, String>(key: "Building")
        XCTAssertNil(treeNode.payload, "Payload for this case should be nil")
    }

    func testSingleNodeCreationWithPayload() {
        XCTAssertNotNil(self.root!, "Payload for this case should not be nil")
    }

    func testIsRoot() {
        XCTAssertTrue(self.root!.isRoot)
    }

    func testNotIsLeaf() {
        XCTAssertFalse(self.root!.isLeaf, "root node is not leaf")
    }

    func testNotIsLeftChild() {
        XCTAssertFalse(self.root!.isLeftChild, "root node is not left child")
    }

    func testNotIsRightChild() {
        XCTAssertFalse(self.root!.isRightChild, "root node is not right child")
    }

    func testIsLeftChild() {
        XCTAssertTrue(self.left!.isLeftChild)
    }

    func testIsRightChild() {
        XCTAssertTrue(self.right!.isRightChild)
    }

    func isLeaf() {
        XCTAssertTrue(self.left!.isLeaf)
    }

    func testHasAnyChild() {
        XCTAssertTrue(self.root!.hasAnyChild)
    }

    func testNotHasAnyChild() {
        XCTAssertFalse(self.left!.hasAnyChild)
    }

    func testHasBothChildren() {
        XCTAssertTrue(self.root!.hasBothChildren)
    }

    func testNotHasBothChildren() {
        XCTAssertFalse(self.left!.hasBothChildren)
    }

}
