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

  describe "Parse to walk" do
    it "shoul have Walky#[] method" do
      lcd_walky.should respond_to(:[])
    end

    it "should parse a simple path" do
      lcd_walky["eletronics"].should be_kind_of(Hash)
    end

    it "should parse a two level path" do
      lcd_walky["eletronics tv"].should be_kind_of(Hash)
    end

    it "should parse a last level path" do
      lcd_walky["eletronics tv screen"].should == "LCD"
    end

    it "should parse by :[] or :walk" do
      lcd_walky["eletronics tv screen"].should == "LCD"
      lcd_walky.walk("eletronics tv screen").should == "LCD"
    end
  end

  describe "Walk through hash" do
    it "should access other with same path" do
      lcd_walky["eletronics tv"].same_path(led).should be_kind_of(Array)
      lcd_walky["eletronics tv"].same_path(led)[0].should == lcd_walky["eletronics tv"]
      lcd_walky["eletronics tv"].same_path(led)[1].should == led["eletronics"]["tv"]
    end

    it "should access multiple other hashes with same path" do
      walked = lcd_walky["eletronics tv"].same_path(led, plasm)
      walked.size.should == 3
      walked[0].should == lcd_walky["eletronics tv"]
      walked[1].should == led["eletronics"]["tv"]
      walked[2].should == plasm["eletronics"]["tv"]
    end

    it "should take all sub hashes with same path" do
      walked = lcd_walky["eletronics tv"].same_path(led, plasm).all do |a, b, c|
        a["screen"].should == "LCD"
        b["screen"].should == "LED"
        c["screen"].should == "PLASM"

        "#{a["screen"]}#{b["screen"]}#{c["screen"]}"
      end
      walked.should == "LCDLEDPLASM"
    end

    it "should iterate between hashes collection" do
      @collection["menu items"].each do |item|
        item["item"].should_not be_nil
      end
    end

    it "should be able to navigate trough an hash" do
      @collection["menu items"].each do |item|
        Walky.move(item, "cat keywords").should be_kind_of(Array)
      end

      Walky.move(@collection["menu items"].first, "cat keywords").size.should == 2
    end

    it 'should walky with symbol keys' do
      command = {
        :type => "ls",
        :params => ["l", "a"]
      }
      Walky.move(command, ":type").should == "ls"
      Walky.move(command, ":params").should == ["l", "a"]
    end

    it 'should walky with symbols and string keys' do
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

    it "should access keys from a sub key" do
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

    it "should access keys from a sub key and symbolize" do
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
end
