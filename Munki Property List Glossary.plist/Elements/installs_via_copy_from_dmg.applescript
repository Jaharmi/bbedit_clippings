set installs_key to "<key>installs</key>" & return & "<array>" & return & "</array>"

tell application "BBEdit"
	set theHFSPath to file of text document 1
	set plistfile_path to POSIX path of theHFSPath
	try
		tell application "System Events"
			set p_list to the property list file (plistfile_path)
			set installer_type to value of property list item "installer_type" of p_list
			if installer_type is "copy_from_dmg" then
				log true
				set items_to_copy_list to (value of property list item "items_to_copy" of p_list)
				set items_to_copy to item 1 of items_to_copy_list
				set destination_path to destination_path of items_to_copy
				set source_item to source_item of items_to_copy
				set the_path to (destination_path & "/" & source_item)
				set quoted_path to (quoted form of the_path)
				set shell_output to (do shell script "/usr/local/munki/makepkginfo -f " & quoted_path)
				set tid to AppleScript's text item delimiters
				set AppleScript's text item delimiters to ASCII character 13
				set shell_paragraphs to the paragraphs of shell_output
				set paragraph_count to the count of shell_paragraphs
				set first_item to 5
				set last_item to (paragraph_count - 3)
				set installs_key to (items first_item through last_item of shell_paragraphs) as text
				set AppleScript's text item delimiters to tid
			else
				return ""
			end if
		end tell
	end try
end tell

return installs_key