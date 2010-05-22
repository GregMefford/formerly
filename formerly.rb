#formerly.rb

module Formerly
  def self.tabs_to_spaces(line, size=8)
    # Tweaked based on code from http://www.bloovis.com/wordpress/?p=19
    # What is does:
    #   substitute all occurrances of:
    #     (stuff other than a tab character),
    #     followed by a tab character
    #   with:
    #     (That stuff we found),
    #     followed by:
    #       x spaces, where x is:
    #         tab size - (length of stuff we found), modulo (tab size)
    # Note: Since that asterisk is there around the [^\t],
    #   the stuff before the tab can be nothing, so this works for \t\t.
    return line.gsub(/([^\t]*)\t/) {$1 + " " * (size - $1.length % size) }
  end
  
  def self.column_candidates(line)
    candidates = []
    # Make sure we get rid of the newline characters
    line.rstrip!
    # Use this variable to keep track of where we've already looked
    search_start = 0
    while true
      # Find all the spaces followed by non-spaces
      candidate = line.index(/ [^ ]/, search_start)
      break if candidate.nil?
      # We want the index of the character, not the space, thus the +1
      candidates << candidate + 1
      # Advance the starting point past the one we just found
      search_start = candidate + 1
    end
    return candidates
  end
  
  def self.common_columns(lines)
    # Find all the candidates in each line
    candidates = lines.map {|line| column_candidates(line)}
    # Find the set intersection across them all
    return candidates.inject {|columns, candidates| columns & candidates}
  end
end
