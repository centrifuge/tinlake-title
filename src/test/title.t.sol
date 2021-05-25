// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.5.15;

import "ds-test/test.sol";

import "../title.sol";

contract TitleUser {
   Title title;
   constructor (Title title_) public {
    title = title_;
   }
   function doIssue(address usr) public returns (uint) {
       return title.issue(usr);
   }
}

contract TitleTest is DSTest {

    function setUp() public {}

    function testSetupPrecondition() public {
        Title title_ = new Title("title", "TLO");
        assertEq(title_.count(), 1);
    }

    function testIssue() public {
        Title title = new Title("title", "TLO");
        TitleUser user = new TitleUser(title);
        title.rely(address(user));
        assertEq(user.doIssue(address(this)), 1);
        assertEq(user.doIssue(address(this)), 2);
        assertEq(user.doIssue(address(this)), 3);
    }
    function testClose() public {
        Title title = new Title("title", "TLO");
        TitleUser user = new TitleUser(title);
        title.rely(address(user));
        assertEq(user.doIssue(address(this)), 1);
        assertEq(user.doIssue(address(this)), 2);
        title.close(1);
        title.close(2);
        assertEq(user.doIssue(address(this)), 3);
    }
    function testFailClose() public {
        Title title = new Title("title", "TLO");
        TitleUser user = new TitleUser(title);
        title.rely(address(user));
        assertEq(user.doIssue(address(this)), 1);
        assertEq(user.doIssue(address(this)), 2);
        title.close(2);
        title.ownerOf(2);
    }
}

contract TitleOwnable is TitleOwned {
    constructor (address title_) TitleOwned (title_) public {
    }

    function testPermission(uint loan) owner(loan) public {
    }
}

contract TitleOwnedTest is DSTest {
    TitleOwnable test;
    Title title;

    address someAddr = 0x29C76e6aD8f28BB1004902578Fb108c507Be341b;

    function setUp() public {
        title = new Title("title", "TLO");
        test = new TitleOwnable(address(title));
    }

    function testLoanPermission() public {
        uint loan = title.issue(address(this));
        test.testPermission(loan);
    }
    function testFailLoanPermissionNonExisting() public {
        // non existing loan
        test.testPermission(12);
    }
    function testFailLoanPermissionWrongOwner() public {
        // wrong owner
        uint loan = title.issue(address(someAddr));
        test.testPermission(loan);
    }
}
