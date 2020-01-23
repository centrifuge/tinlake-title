// title.sol -- NFT to manage access rights to contracts
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

pragma solidity >=0.5.12;

import { ERC721Metadata } from "./openzeppelin-solidity/token/ERC721/ERC721Metadata.sol";
import { Auth } from "tinlake-auth/auth.sol";

contract Title is Auth, ERC721Metadata {
    // --- Data ---
    uint public count;
    string public uri;

    constructor (string memory name, string memory symbol) ERC721Metadata(name, symbol) public {
        wards[msg.sender] = 1;
        count = 1;
    }

    // --- Title ---
    function issue (address usr) public auth returns (uint) {
        return _issue(usr);
    }

    function _issue (address usr) internal returns (uint) {
        _mint(usr, count);
        count += 1; // can't overflow, not enough gas in the world to pay for 2**256 nfts.
        return count-1;
    }

    function close (uint tkn) public auth {
        _burn(tkn);
    }
}

contract TitleLike {
    function ownerOf (uint) public returns (address);
}

contract TitleOwned {
    TitleLike title;
    constructor (address title_) public {
        title = TitleLike(title_);
    }

    modifier owner (uint loan) { require(title.ownerOf(loan) == msg.sender); _; }
}
