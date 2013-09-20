# Twirb

Simple Ruby text editor as a ruby gem
==============================================

This is a little tool with syntax highlighting and indentation for writing ruby code and execute it directly in your terminal thanks to some useful command listed below: It can be used in three different ways:
auto mode(default option): automatic syntax highlighting and indentation and numerated lines while writing your code.
edit mode: if you want to add some thing to the code written so far you can activate the edit mode hitting Escape-key: in this way automatic indentation and highlight will be deactivated in order to allow changes.
After that you can reactivat auto mode hitting double-key-Escape and then space key: in this way the code that you added will be automatic formatted and you can continue writing in auto mode.
text mode: pressing control-q the code will be converted as if in a text file making all the changes you want. You can reactivate auto mode every time you want just hitting control-w and then space key. the code will be automatic formatted.
You can execute the code you have written so far just pressing control-e: in this way the code will be executed on your terminal as if in irb. 
For other commands and instructions visit http://www.twirb.org

## Installation

Twirb needs "tk" that is the standard graphical user interface for Ruby.
The Ruby Tk bindings are distributed with Ruby but Tk is a separate installation. Windows users can download a single click Tk installation from ActiveState's ActiveTcl(http://www.activestate.com/activetcl/downloads)

Mac and Linux users may not need to install it because there is a great chance that its already installed along with OS but if not, you can download prebuilt packages or get the source from the Tcl Developer Xchange(http://www.tcl.tk/software/tcltk/downloadnow84.tml).
For more details you can visit Tkdocs(http://www.tkdocs.com/tutorial/install.html)

Add this line to your application's Gemfile:

    gem 'twirb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twirb

## Usage

you can use it simply typing 

$ twirb

in the command line.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
