## Walky - Simple lib to access easily hashes with multiple keys

[![Build
Status](https://secure.travis-ci.org/jhonnyquest/walky.png?branch=master)](http://travis-ci.org/jhonnyquest/walky)


Walky create a simple interface to access hashes with many keys.
You can can access multiple level keys or events, use same "path" of one
hash to access directly this sequence os keys in other hash.

Example: Given this hash

```ruby
@hash = { "menu" => {
  "header"   => {
    "screen" => "LCD",
    "meme"   => "Like a boss"
  }
}
```
With Walky, we could just do this:

```ruby
@walky = Walky::Walker.new(@hash)

@walky["menu header screen"]      # => "LCD"
# Or:
@walky.move("menu header screen") # => "LCD"
```

If you want to access multiple hashes that have the equals keys, you can use
<tt>Walky#same_path</tt>.

Example:

```ruby
@other    = { "menu" => { "header" => { "screen" => "LED"  , "meme" => "Poker face" } } }
@more_one = { "menu" => { "header" => { "screen" => "PLASM", "meme" => "LOL"        } } }

# Acessing multiple hashes with one hash key
@walky["menu header"].same_path(@other, @more_one).all do |a, b, c|
  a["screen"] # => "LCD"
  b["screen"] # => "LED"
  c["screen"] # => "PLASM"
end
```

That's it. Feel free to contribute


