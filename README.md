## My personal Emacs configuration

Most of the settings here are on top of the magnificent  [Scimax Emacs distribution](https://github.com/jkitchin/scimax/). It also includes many functions that I have wrote and collected that are useful to me. Also, a few packages that I use that are not available in MELPA.  

If you are interested to try it out, then download [Scimax](https://github.com/jkitchin/scimax/) and place all the files here inside the `scimax/user` folder.  

`user.el` file is loaded by Scimax after it does all its loading. My `user.el` loads `functions.el`, `bindings.el`, and `settings.el`. Mostly, I have stuck to keeping these separate, but most new packages that I have added using `use-package`. The packages using `use-package` have all the functions, bindings, and settings included within the `use-package` load. All the `use-package` loads are in the `functions.el` under all the initial `require` statements.  

For Non-MacOS users, certain settings need to be slightly modified, but should largely work with little modification on Unix-based systems (currently most things work running a session remotely from AWS Debian instance).
