pragma solidity ^0.5.12;

import "ds-test/test.sol";

import "./TinlakeTitle.sol";

contract TinlakeTitleTest is DSTest {
    TinlakeTitle title;

    function setUp() public {
        title = new TinlakeTitle();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
