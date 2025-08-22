# aseprite-el - Interact with Aseprite from the comfort of Emacs.

## Table of contents

- [Installation](#installation)
  - [Manual (Clone)](#1-manual-clone)
  - [Using straight.el](#2-using-straightel)
- [Basic usage](#basic-usage)
- [Configuration](#configuration)
- [License](#license)

## Installation

### Manual (Clone)

Execute the following in your terminal:

``` shell
git clone https://github.com/yelobat/aseprite-el.git ~/.emacs.d/aseprite-el
```

Add the directory to your Emacs `load-path` and require the package in your init file:

``` emacs-lisp
(add-to-list 'load-path "~/.emacs.d/aseprite-el")
(require 'aseprite)
```

Use `C-c C-e (elisp-eval-region-or-buffer)` or simply restart Emacs for the changes to take effect.


### **`straight.el`**

If you have `straight.el`, simply add the repo to your `straight-use-package` list:

``` emacs-lisp
(straight-use-package
 '(aseprite-el
   :type git
   :host github
   :repo "yelobat/aseprite-el"))
(require 'aseprite)
```

Use `C-c C-e (elisp-eval-region-or-buffer)` or simply restart Emacs for the changes to take effect.

## Basic usage

The only thing you will need is the following command:
``` emacs-lisp
M-x aseprite-menu
```
This will open the transient menu that displays all of the currently available commands.

## Configuration (optional)

``` emacs-lisp
;; Path to your aseprite binary.
(setq aseprite-cli-path "/usr/local/bin/aseprite")
```

## License

This project is released under the `GNU General Public License v3.0`. See `LICENSE` for more details.
