# formerly_spec.rb
require 'formerly'

describe Formerly, "Best-Case text-scraping" do
	it "knows how to expand tabs to spaces intelligently" do
		input    = "This	is	some	text	that	has	4-space	tabs	in	it."
		expected = "This    is  some    text    that    has 4-space tabs  in    it."
		result = Formerly.tabs_to_spaces input
		result.should == expected
  end
end