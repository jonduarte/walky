require 'walky'

describe Walky do
  let(:lcd) { { "eletronics" => { "tv" => { "screen" => "LCD", "digital" => true } } } }
  let(:lcd_walky) { Walky::Walker.new(lcd) }

  describe '.move' do
    it 'parse symbols and string keys' do
      print = {
        "file" => {
          :type => "A4",
          :pages => [1, 2, 3],
          "password" => "secret"
        }
      }
      Walky.move(print, "file :type").should == "A4"
      Walky.move(print, "file password").should == "secret"
    end

    it 'parse only symbol params' do
      command = {
        :type   => "ls",
        :params => ["l", "a"]
      }
      Walky.move(command, ":type").should == "ls"
      Walky.move(command, ":params").should == ["l", "a"]
    end

    it 'ensure that can navigate when iterating' do
      collection = Walky::Walker.new({
        "menu" => {
          "items" => [
            {"item" => "Movie",   "cat" => {"keywords" => ["movie", "stories"]    }},
            {"item" => "Shop",    "cat" => {"keywords" => ["buy", "bussiness"]    }},
            {"item" => "Stadium", "cat" => {"keywords" => ["joy", "watch", "fun"] }},
          ]
        }
      })

      collection["menu items"].each do |item|
        Walky.move(item, "cat keywords").should be_kind_of(Array)
      end

      Walky.move(collection["menu items"].first, "cat keywords").size.should == 2
    end

    it "returns new hash root" do
      print = {
        "file" => {
          :type => "A4",
          :pages => [1, 2, 3],
          "password" => "secret"
        }
      }
      keys = Walky.move(print, "file")
      keys[:type].should == "A4"
      keys[:pages].should == [1, 2, 3]
      keys["password"].should == "secret"

      extracted = lcd_walky.move("eletronics tv")
      extracted["screen"] = "LCD"
    end
  end
end
