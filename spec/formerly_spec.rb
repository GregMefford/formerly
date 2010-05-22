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
    @lines = @subject.split(/[\r\n]/).reject {|item| item == ""}
  end

  it "finds all possible columns" do
    expected = [
      [ 5,  8, 17, 26, 33, 38, 43, 51, 53],
      [ 5,  9, 17, 21, 25, 33, 38, 51],
      [ 2,  7, 17, 22, 26, 33, 41, 46, 51, 56],
      [17, 20, 25, 33, 51]
    ]
    # Check each line
    expected.each_index do |i|
      Formerly.column_candidates(@lines[i]).should == expected[i]
    end
  end
  
  it "guesses where the columns are given a group of candidates" do
    Formerly.common_columns(@lines).should == [17, 33, 51]
  end
end

describe Formerly, "Parses multiple different-sized tables in a document" do
# For manually calculating my expected outcome, here it is with a ruler:
#     |0   |5   |10  |15  |20  |25  |30  |35  |40  |45  |50  |55  |60
# 0: Here is a file header, just for good measure and confusion
#
# 1: This is a header that happens to match the content columns
# 2: This is some     columnar text   that acts like    a table
# 3: when you expand  all the tabs    into spaces,      which
# 4: I have already   done for this   example just to   make it
# 5: easier           to read and     follow            along
#
# 6: This header obviously does not match up with the content
# 7: This     is    a           smaller       table
# 8: designed to    demonstrate that is can   find
# 9: two different  tables with different     dimensions
  before(:all) do
    @subject  = "Here is a file header, just for good measure and confusion\r\n"
    @subject << "\r\n"
    @subject << "This is a header that happens to match the content columns\r\n"
    @subject << "This is some     columnar text   that acts like    a table\r\n"
    @subject << "when you expand  all the tabs    into spaces,      which\n"
    @subject << "I have already   done for this   example just to   make it\r\n"
    @subject << "easier           to read and     follow            along\n"
    @subject << "\n"
    @subject << "\r"
    @subject << "\r\n"
    @subject << "This header obviously doesn't match up with the content\r\n"
    @subject << "This           is a        smaller       table\r\n"
    @subject << "designed to    demonstrate that is can   find\n"
    @subject << "two different  tables with different     dimensions\r\n"
    @lines = @subject.split(/[\r\n]/).reject {|item| item == ""}
  end

  it "finds the lines that are likely to comprise a table" do
    file_header = 0..0
    # Nothing I can do about this header getting merged into the table. :,(
    table_1 = 1..5
    table_2_header = 6..6
    table_2 = 7..9
    expected = [file_header, table_1, table_2_header, table_2]
    Formerly.find_tables(@lines).should == expected
  end
end