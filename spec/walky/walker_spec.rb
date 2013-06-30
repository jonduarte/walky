require 'walky'

module Walky
  describe Walker do
    let(:lcd) { { "eletronics" => { "tv" => { "screen" => "LCD", "digital" => true } } } }
    let(:led) { { "eletronics" => { "tv" => { "screen" => "LED", "digital" => false } } } }
    let(:plasm) { { "eletronics" => { "tv" => { "screen" => "PLASM", "digital" => true } } } }

    let(:lcd_walky) { Walky::Walker.new(lcd) }
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

    describe '#move' do
      it 'parse hash values' do
        lcd_walky.move("eletronics tv screen").should == lcd_screen
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
  end
end
