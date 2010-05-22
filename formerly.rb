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
    candidates = all_candidates(lines)
    # Find the set intersection across them all
    return candidates.inject {|columns, candidates| columns & candidates}
  end
  
  def self.find_tables(lines)
    last_line = lines.length - 1
    tables = []
    # Yes, this is an O(n^2) algorithm. I don't really care.
    lines.each_index do |start_line|
      # For each line, find the following lines that match some of the columns
      previous = []
      (start_line..last_line).each do |end_line|
        common = common_columns(lines[start_line..end_line])
        if common == []
          tables << [start_line..end_line-1, previous]
          break
        else
          previous = common
        end
        # Special case for the last line in the file being a table member
        tables << [start_line..end_line, common] if end_line == last_line
      end
    end
    # At this point, we should have collected all the possible tables
    # and we just need to eliminate the sub-optimal ones (proper subsets, etc)
    tables.reject! do |range, columns|
      tables.any? do |other_range, other_columns|
        # Don't compare the range with itself
        if range == other_range
          false
        else
          # This range is a proper subset of another in the table list
          other_range.member? range.first and other_range.member? range.last
        end
      end
    end
    # Now what we have are some (probably good) tables,
    # but if there are non-tabular header rows, they may be encroaching into
    # part of the table that happens to match.
    # The best we can do is just truncate any ranges where another range
    # starts in the middle of it.
    tables.each_with_index do |item, i|
      range, columns = item
      tables.each do |other_range, other_columns|
        # Don't compare the range with itself
        next if range == other_range
        # This the other range starts in the middle of the current one,
        if range.member? other_range.first
          # truncate the current one and re-scan the columns for it
          range = range.first..other_range.first-1
          columns = common_columns(lines[range])
          tables[i] = [range, columns]
        end
      end
    end
    return tables
  end
  
  def self.parse_single_table(lines, range, columns)
    parsed_array = []
    lines[range].each do |line|
      parsed_line = []
      start_index = 0
      # Pull out the text from each slot in the columns list
      columns.each do |end_index|
        # Strip off white space before and after it to clean it up.
        parsed_line << line[start_index..end_index-1].strip
        # Advance to the next slot
        start_index = end_index
      end
      # Special case for the tail of the line:
      parsed_line << line[start_index..-1].strip
      # Push the parsed line into the array
      parsed_array << parsed_line
    end
    return parsed_array
  end
  
  def self.find_and_parse_all_tables(lines)
  end

private
  def self.all_candidates(lines)
    # Find all the candidates in each line
    return lines.map {|line| column_candidates(line)}
  end
end
