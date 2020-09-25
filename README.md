# `autoconda`

Fish shell plugin to automatically activate/deactivate Python virtual enviroments upon entering/leaving a directory.

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)

## Install

Installation with [`fisher`](https://github.com/jorgebucaran/fisher):

  ```shell
  fisher add harmtemolder/fish-autoconda
  ```

(The original plugin was for [`omf`](https://github.com/oh-my-fish/oh-my-fish).)

## About

[Timothy Brown](https://github.com/timothybrown) wrote [an excellent plugin to switch environments with Python 3 venvs](https://github.com/timothybrown/fish-autovenv). I forked that plugin and rewrote it to handle conda environments instead.

## Usage

Upon entering a directory that contains an `environment.yml` file—or any directory below it—`autoconda` will automatically take the value of `prefix` from it and activate that  for you. Likewise, when moving outside the environment's root directory `autoconda` will deactivate it! `autoconda` can also handle cases where you move directly from one environment directory to another.

## Settings

<code>set -U autoconda_enable <b>yes</b>/no</code>:
  Enables/disables `autoconda` functionality.
<code>set -U autoconda_announce <b>yes</b>/no</code>:
  Controls whether or not a message is printed when entering/leaving/changing environments.
<code>set -U autoconda_debug yes/<b>no</b></code>:
  Adds extreme verbosity for debugging.

(**Bold** are defaults.)

## License
[MIT](http://opensource.org/licenses/MIT) © [Harm te Molder](https://github.com/harmtemolder)
