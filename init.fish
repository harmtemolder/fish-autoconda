################################################################################
############  AutoConda for Fish Shell, based on                    ############
############  AutoVenv for Fish Shell v2019.03.28 by @TimothyBrown  ############
################################################################################

## AutoConda Settings
if status is-interactive
  test -z "$autoconda_announce"
    and set -g autoconda_announce "yes"
  test -z "$autoconda_enable"
    and set -g autoconda_enable "yes"
  test -z "$autoconda_debug"
    and set -g autoconda_debug "no"
end

## AutoConda Function
# Activates on directory changes.
function autoconda --on-variable PWD -d "Automatic activation of Python virtual environments"

  if test "$autoconda_debug" = "yes"; echo "Started autoconda"; end
  if test "$autoconda_debug" = "yes"; echo "__autoconda_old = $__autoconda_old"; end
  if test "$autoconda_debug" = "yes"; echo "__autoconda_new = $__autoconda_new"; end

  # Check for the enable flag and make sure we're running interactive, if not return.
  test ! "$autoconda_enable" = "yes"
    or not status is-interactive
    and return

  # We start by splitting our CWD path into individual elements and iterating over each element.
  # If our CWD is `/opt/my/hovercraft/eels` we split it into a variable containing 4 entries:
  # `opt`, `my`, `hovercraft` and `eels`. We then build back up the path by iterating over the list
  # and adding each element to the previous one. (We start with `/opt`, then `/opt/my` and so on.)
  # During each run through the loop we test for a file called `environment.yml`. If a
  # conda environment is found we go ahead and break out of the loop, otherwise continue. We go through all of this
  # instead of just checking the CWD to handle cases where the user moves into a sub-directory of the conda environment.

  for _dir in (string split -n '/' "$PWD")
    set -l _tree "$_tree/$_dir"

    if test "$autoconda_debug" = "yes"; echo "_tree = $_tree"; end

    if test -e "$_tree/environment.yml"
      set _source "$_tree/environment.yml"

      if test "$autoconda_debug" = "yes"; echo "_source = $_source"; end

      set -g __autoconda_old $__autoconda_new
      set -xg __autoconda_new $_tree  # Export this for future runs

      if test "$autoconda_debug" = "yes"; echo "__autoconda_old = $__autoconda_old"; end
      if test "$autoconda_debug" = "yes"; echo "__autoconda_new = $__autoconda_new"; end

      break
    end
  end

  # If we're *not* in an active conda environment and the conda environment source dir exists we activate it and return.
  if test -z "$CONDA_DEFAULT_ENV" -a -e "$_source"

    if test "$autoconda_debug" = "yes"; echo "_source, but no CONDA_DEFAULT_ENV"; end

    __autoconda_activate_from_file "$_source"

    if test "$autoconda_announce" = "yes"
      echo "Activated Virtual Environment ($__autoconda_new)"
    end

  # Next we check to see if we're already in an active conda environment. If so we proceed with further tests.
  else if test -n "$CONDA_DEFAULT_ENV"

    if test "$autoconda_debug" = "yes"; echo "CONDA_DEFAULT_ENV = $CONDA_DEFAULT_ENV"; end
    if test "$autoconda_debug" = "yes"; echo "PWD = $PWD"; end

    # Check to see if our CWD is inside the conda environment's root.
    set _dir (string match "$__autoconda_old*" "$PWD")
    if test "$autoconda_debug" = "yes"; echo "_dir = $_dir"; end

    # If we're no longer inside the conda environment root deactivate it and return.
    if test -z "$_dir" -a ! -e "$_source"

      if test "$autoconda_debug" = "yes"; echo "Outside of conda env root"; end

      conda deactivate

      if test "$autoconda_announce" = "yes"
        echo "Deactivated Virtual Enviroment ($__autoconda_new)"
      end

      set -e __autoconda_new
      set -e __autoconda_old

    # If we've switched into a different conda environment directory, deactivate the old and activate the new.
    else if test -z "$_dir" -a -e "$_source"

      if test "$autoconda_debug" = "yes"; echo "Switched to different conda env"; end

      __autoconda_activate_from_file "$_source"

      if test "$autoconda_announce" = "yes"
        echo "Switched Virtual Environments ($__autoconda_old => $__autoconda_new)"
      end
    else
      if test "$autoconda_debug" = "yes"; echo "Impossible"; end
    end
  else
    if test "$autoconda_debug" = "yes"; echo "No _source and no CONDA_DEFAULT_ENV"; end
  end
end

function __autoconda_activate_from_file -d "Activates a conda environment mentioned in a given environment.yml"
  if test "$autoconda_debug" = "yes"; echo "Started __autoconda_activate_from_file"; end

  set -l environment_yml $argv[1]
  set -l prefix_line (cat $environment_yml | grep "^prefix:")
  set -l prefix_split (string split -n " " $prefix_line)
  set -l prefix_from_file $prefix_split[2]

  if test "$autoconda_debug" = "yes"; echo "environment_yml = $environment_yml"; end
  if test "$autoconda_debug" = "yes"; echo "prefix_line = $prefix_line"; end
  if test "$autoconda_debug" = "yes"; echo "prefix_split = $prefix_split"; end
  if test "$autoconda_debug" = "yes"; echo "prefix_from_file = $prefix_from_file"; end

  conda activate $prefix_from_file
end
################################################################################
