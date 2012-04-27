KAG [![Build Status][travp]][trav]
==================================

* [https://github.com/kyrylo/ruby-kag/][rkag]

Description
-----------

This is [King Arthur's Gold][kag] API wrapper implemented in Ruby language.

Features
--------

* Ability to retrieve information about player (nick, role and so on)
* Ability to retrieve player's avatar on [KAG forums][kagf]

Installation
------------

    gem install ruby-kag

Synopsis
--------

``` ruby
require 'kag'

player = KAG::Player.new('prostosuper')

# Get small avatar of player prostosuper
player.avatar.small

# Force request to API to refresh player's small avatar
player.avatar.small(true)

# Get all information about player
player.info
```

License
-------

The project uses Zlib License. See LICENSE file for more information.

[rkag]: https://github.com/kyrylo/ruby-kag/ "Home page"
[kag]: http://kag2d.com/
[kagf]: https://forum.kag2d.com/
[travproject]: https://secure.travis-ci.org/kyrylo/ruby-kag.png?branch=master
[travimg]: http://travis-ci.org/kyrylo/ruby-kag
