Installator
===========

A very simple OS X installing script, that will install Homebrew, Homebrew-cask and all the brews and casks you want.

Instructions
------------

* Install Xcode from the app store
* Start Xcode to agree to the terms or plenty of things won't work
* Install Xcode command line tools: `sudo xcode-select --install`
* Edit `Brews` to include all the command line tools, libraries, etc. you want to have. You can search for packages [here](http://braumeister.org)
* Edit `Casks` to include all the GUI programs you want to have. You can try looking [here](https://github.com/phinze/homebrew-cask/tree/master/Casks) to see what packages are available
* Run `ruby installator.rb`
* ????
* Profit! (And see installator.log for details on what has happened)

Alternatives
------------

If you want something similar that does all this and much more, I recommend looking into Pivotal's [sprout-wrap](https://github.com/pivotal-sprout/sprout-wrap).
If you want something even more simple, you should take a look at [Get Mac Apps](http://getmacapps.com).