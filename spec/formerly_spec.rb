# formerly_spec.rb
require 'formerly'

describe Formerly, "Best-Case text-scraping" do
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
