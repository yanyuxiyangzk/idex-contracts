// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.8;


library UUID {
  // https://tools.ietf.org/html/rfc4122#section-4.1.2
  function getTimestampFromUuidV1(uint128 uuid) internal pure returns (uint64) {
    uint128 version = (uuid >> 76) & 0x0000000000000000000000000000000F;
    require(version == 1, 'Must be v1 UUID');

    // Time components are in reverse order so shift+mask each to reassemble
    uint128 timeHigh = (uuid >> 16) & 0x00000000000000000FFF000000000000;
    uint128 timeMid = (uuid >> 48) & 0x00000000000000000000FFFF00000000;
    uint128 timeLow = (uuid >> 96) & 0x000000000000000000000000FFFFFFFF;
    uint128 nsSinceGregorianEpoch = (timeHigh | timeMid | timeLow);
    // Gregorian offset given in seconds by https://www.wolframalpha.com/input/?i=convert+1582-10-15+UTC+to+unix+time
    uint64 msSinceUnixEpoch = uint64(nsSinceGregorianEpoch / 10000) -
      12219292800000;

    return msSinceUnixEpoch;
  }
}