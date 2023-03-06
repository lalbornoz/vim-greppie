vim-greppie
===========

Fork of <https://github.com/yegappan/grep/fork> implementing the following
additional features:

1) Implements key mappings in Grep output window.
2) Directly pass command lines to shell unchanged.

This fixes the following upstream issues:
<https://github.com/yegappan/grep/issues/9>
<https://github.com/yegappan/grep/issues/11>
<https://github.com/yegappan/grep/issues/17>

Removes find and xargs dependencies.
    
Removes the following features/options:  
Prompting for \<search_pattern\> if not specified  
Prompting for \<file_names\> if not specified  
Grep\_Find\_Path  
Grep\_Xargs\_Path  
Grep\_Default\_Filelist  
Grep\_Find\_Use\_Xargs  
Grep\_Xargs\_Options  
Grep\_Cygwin\_Find  
Grep\_Shell\_Escape\_Char

N.B.	Due to Vim limitations, filenames containing special Shell characters
such as: &, (, ), \*, ?, [, ], \`, $ must be escaped manually.

Plugin to integrate various grep like search tools with Vim.

The grep plugin integrates grep like utilities (grep, fgrep, egrep, agrep,
findstr, silver searcher (ag), ripgrep, ack, git grep, sift, platinum searcher
and universal code grep) with Vim and allows you to search for a pattern in one
or more files and jump to them.

In Vim version 8.0 and above, the search command is run asynchronously
in the background and the results are added to a quickfix list.

This plugin works only with Vim and not with neovim.

To use this plugin, you will need the grep like utilities in your system.  If a
particular utility is not present, then you cannot use the corresponding
features, but you can still use the rest of the features supported by the
plugin.

To use the this plugin with grep, you will need the grep, fgrep and egrep
utilities. To recursively search for files using grep, you will need the find
and xargs utilities. These tools are present in most of the Unix and MacOS
installations.  For MS-Windows systems, you can download the GNU grep and find
utilities from the following sites:

    http://gnuwin32.sourceforge.net/packages/grep.htm
    http://gnuwin32.sourceforge.net/packages/findutils.htm

On MS-Windows, you can use the findstr utility to search for patterns.
This is available by default on all MS-Windows systems.

The plugin supports various search utilities listed in the table below.

Search Tool | Home Page | Grep Plugin Command |
----------- | ----------| --------------------|
Ripgrep | https://github.com/BurntSushi/ripgrep | :Rg
Silver Searcher | https://github.com/ggreer/the_silver_searcher | :Ag
Git grep | https://git-scm.com/ | :Gitgrep
Ack | https://beyondgrep.com/ | :Ack
Sift | https://sift-tool.org | :Sift
Platinum Searcher | https://github.com/monochromegane/the_platinum_searcher | :Ptgrep
Universal Code Grep | https://gvansickle.github.io/ucg | :Ucgrep
agrep | https://www.tgries.de/agrep | :Agrep

The ripgrep, silver searcher, git grep, ack, sift, platinum searcher and
universal code grep utilities can search for a pattern recursively
across directories without using any other additional utilities like
find and xargs.
