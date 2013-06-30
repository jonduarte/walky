require 'walky'

describe Walky do

  let(:lcd) { { "eletronics" => { "tv" => { "screen" => "LCD", "digital" => true } } } }
  let(:led) { { "eletronics" => { "tv" => { "screen" => "LED", "digital" => false } } } }
  let(:plasm) { { "eletronics" => { "tv" => { "screen" => "PLASM", "digital" => true } } } }

  let(:lcd_walky) { Walky::Walker.new(lcd) }

  before do
    @menu_items = {
      "menu" => {
        "items" => [
          {"item" => "Movie", "cat" => { "keywords" => ["movie", "stories"]}},
          {"item" => "Shop", "cat" => {"keywords" => ["buy", "bussiness"]}},
          {"item" => "Stadium", "cat" => {"keywords" => ["joy", "watch", "fun"]}},
        ]
      }
    }

    @collection = Walky::Walker.new(@menu_items)
  end

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
  end

  describe '.extract' do
    it "change hash root" do
      print = {
        "file" => {
          :type => "A4",
          :pages => [1, 2, 3],
          "password" => "secret"
        }
      }
      keys = Walky.extract(print, "file")
      keys[:type].should == "A4"
      keys[:pages].should == [1, 2, 3]
      keys["password"].should == "secret"

      extracted = lcd_walky.extract("eletronics tv")
      extracted["screen"] = "LCD"
    end
  end

  describe '.extract_with_sym' do
    it "change hash root and symbolize hash keys" do
      print = {
        "file" => {
          :type => "A4",
          :pages => [1, 2, 3],
          "password" => "secret"
        }
      }

      keys = Walky.extract_with_sym(print, "file")
      keys[:type].should == "A4"
      keys[:password].should == "secret"
    end
  end

  describe Walky::Walker do
    let(:lcd_screen) { lcd["eletronics"]["tv"]["screen"] }

    describe '#[]' do
      it 'parse hash values' do
        lcd_walky["eletronics"].should be_kind_of(Hash)
      end

      it "parse two level path" do
        lcd_walky["eletronics tv"].should be_kind_of(Hash)
      end

      it "parse last level path" do
        lcd_walky["eletronics tv screen"].should == lcd_screen
      end
    end

    describe '#walk' do
      it 'parse hash values' do
        lcd_walky.walk("eletronics tv screen").should == lcd_screen
      end
    end

    describe '#same_path' do
      it 'access two hash with same path at same time' do
        lcd_walky["eletronics tv"].same_path(led).should be_kind_of(Array)
        lcd_walky["eletronics tv"].same_path(led)[0].should == lcd_walky["eletronics tv"]
        lcd_walky["eletronics tv"].same_path(led)[1].should == led["eletronics"]["tv"]
      end

      it 'access multiple hashes with same path at same time' do
        walked = lcd_walky["eletronics tv"].same_path(led, plasm)
        walked.size.should == 3
        walked[0].should == lcd_walky["eletronics tv"]
        walked[1].should == led["eletronics"]["tv"]
        walked[2].should == plasm["eletronics"]["tv"]
      end

      it 'can also access sub paths from all related hashes' do
        walked = lcd_walky["eletronics tv"].same_path(led, plasm).all do |a, b, c|
          a["screen"].should == "LCD"
          b["screen"].should == "LED"
          c["screen"].should == "PLASM"

          "#{a["screen"]}#{b["screen"]}#{c["screen"]}"
        end
        walked.should == "LCDLEDPLASM"
      end
    end

    describe '#each' do
      it 'ensure that each work properly' do
        @collection["menu items"].each do |item|
          item["item"].should_not be_nil
        end
      end

      it 'ensure that can navigate when iterating' do
        @collection["menu items"].each do |item|
          Walky.move(item, "cat keywords").should be_kind_of(Array)
        end

        Walky.move(@collection["menu items"].first, "cat keywords").size.should == 2
      end
    end
  end
end
