// Copyright (C) 2019 lucasvo

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
