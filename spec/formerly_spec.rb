# formerly_spec.rb
require 'formerly'

describe Formerly, "Converts tabs to spaces" do
  it "knows how to expand 2-space tabs to spaces intelligently" do
    input    = "This\tis\tsome\ttext\tthat\thas\t\t2-space\ttabs\tin\tit."
    expected = "This  is  some  text  that  has   2-space tabs  in  it."
    result = Formerly.tabs_to_spaces input, 2
    result.should == expected
  end

  it "knows how to expand 4-space tabs to spaces intelligently" do
    input    = "This\tis\tsome\ttext\tthat\thas\t\t4-space\ttabs\tin\tit."
    expected = "This    is  some    text    that    has     4-space tabs    in  it."
    result = Formerly.tabs_to_spaces input, 4
    result.should == expected
  end

  it "knows how to expand 8-space tabs to spaces intelligently" do
    input    = "This\tis\tsome\ttext\tthat\thas\t\t8-space\ttabs\tin\tit."
    expected = "This    is      some    text    that    has             8-space tabs    in      it."
    result = Formerly.tabs_to_spaces input, 8
    result.should == expected
  end
end

describe Formerly, "Guesses where columns are in a space-aligned table" do
# For manually calculating my expected outcome, here it is with a ruler:
#  |0   |5   |10  |15  |20  |25  |30  |35  |40  |45  |50  |55  |60
#  This is some     columnar text   that acts like    a table
#  when you expand  all the tabs    into spaces,      which
#  I have already   done for this   example just to   make it
#  easier           to read and     follow            along
  before(:all) do
    @subject  = "This is some     columnar text   that acts like    a table\r\n"
    @subject << "when you expand  all the tabs    into spaces,      which\n"
    @subject << "I have already   done for this   example just to   make it\r\n"
    @subject << "easier           to read and     follow            along\n"
  end

  it "finds all possible columns" do
    expected = [
      [ 5,  8, 17, 26, 33, 38, 43, 51, 53],
      [ 5,  9, 17, 21, 25, 33, 38, 51],
      [ 2,  7, 17, 22, 26, 33, 41, 46, 51, 56],
      [17, 20, 25, 33, 51]
    ]
    # Check each line
    lines = @subject.split(/[\r\n]/).reject {|item| item == ""}
    expected.each_index do |i|
      Formerly.column_candidates(lines[i]).should == expected[i]
    end
  end
end