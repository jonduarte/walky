## Walky - Simple lib to walky through easily hashes and arrays

Walky try create a simple way to access hashes and arrays with many keys easily. 
Trying to use css-selectors-like, you can move through arrays and hashes and also access others hashes with the _same path_

Example:

```ruby
@hash = { "menu" => { 
  "header" => {
    "screen" => "LCD", 
    "meme"   => "Like a boss"
  }
}
```

If we have an hash like above, you can use Walky like this:

```ruby
@walky = Walky::Walker.new(@hash)

@walky["menu header screen"]      # => "LCD"
# Or, other way:
@walky.walk("menu header screen") # => "LCD" 
```

Using you want to access multiple hashes that have the same keys that the first, you can use
<tt>Walky#same_path</tt>. Example using with the code above:

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
