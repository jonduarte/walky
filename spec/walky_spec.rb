require 'walky'

describe Walky do

  # Load resources
  # =============
  before do
    @hash = {"menu"=>{"header"=> {"screen"=>"LCD", "meme" => "Like a boss"}}}
    @other = {"menu"=>{"header"=> {"screen"=>"LED", "meme" => "Poker face"}}}
    @more_one = {"menu"=>{"header"=> {"screen"=>"PLASM", "meme" => "LOL"}}}
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
    @walky = Walky::Walker.new(@hash)
  end

  # Examples
  # =======
  describe "Parse to walk" do
    it "shoul have Walky#[] method" do
      @walky.should respond_to(:[])
    end

    it "should parse a simple path" do
      @walky["menu"].should be_kind_of(Hash)
    end

    it "should parse a two level path" do
      @walky["menu header"].should be_kind_of(Hash)
    end

    it "should parse a last level path" do
      @walky["menu header screen"].should == "LCD" 
    end

    it "should parse by :[] or :walk" do
      @walky["menu header screen"].should == "LCD" 
      @walky.walk("menu header screen").should == "LCD" 
    end
  end

  describe "Walk through hash" do
    it "should access other with same path" do
      @walky["menu header"].same_path(@other).should be_kind_of(Array)
      @walky["menu header"].same_path(@other)[0].should == @walky["menu header"]
      @walky["menu header"].same_path(@other)[1].should == @other["menu"]["header"]
    end

    it "should access multiple other hashes with same path" do
      walked = @walky["menu header"].same_path(@other, @more_one)
      walked.size.should == 3
      walked[0].should == @walky["menu header"]
      walked[1].should == @other["menu"]["header"]
      walked[2].should == @more_one["menu"]["header"]
    end
    
    it "should take all sub hashes with same path" do
      walked = @walky["menu header"].same_path(@other, @more_one).all do |a, b, c|
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
  end
end
