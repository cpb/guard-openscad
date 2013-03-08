guard-openscad -- A Guard plugin for OpenSCAD
=============================================

## DESCRIPTION

guard-openscad provides a Guardfile configuration interface for running .scad files through OpenSCAD as you change them. This is helpful if you:

* Prefer editing outside of OpenSCAD and want some syntax checking
* Want to automatically output STL files for quickly slicing


## INSTALLATION

The preferred way of installing guard-openscad is through bundler. Out of the box, it provides you reasonable defaults for at least quickly checking syntax.

1. Add guard-openscad to your Gemfile in a directory for your new thing.

    gem "guard-openscad"

1. Run `bundle install` to install guard-openscad and all its dependencies.
1. Setup your Guardfile with `bundle exec guard init`. This will provide you a default Guardfile configured to watch for changes to .scad files in a subdirectory called scad.
1. Run guard with `bundle exec guard`

## USAGE

Now, with guard running, try creating a new scad file, `scad/cube.scad`

    cube(10,10,10);

When you save it, guard observes the change, and runs it through openscad! You'll get a notification showing you everything is OK and a .csg version of the file.

## Contributing to guard-openscad
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Caleb Buxton. See LICENSE.txt for
further details.
