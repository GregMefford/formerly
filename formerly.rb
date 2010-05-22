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
end
