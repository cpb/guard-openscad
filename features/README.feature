Feature: A Guard plugin which runs .scad files through OpenSCAD
  OpenSCAD guard provides automatic SCAD processing, it can:
  - Compile to CSG for fast syntax checking.
  - Render to STL for slicing.

  Scenario: Installation
    Given Add to your `Gemfile`
    """
    gem "guard-openscad", path: "/Users/caleb/Projects/guard-openscad"
    """
    And Run `bundle install`
    And Setup your Guardfile `bundle exec guard init`
    And Run `bundle exec guard`
    When You create a new scad file `scad/cube.scad`
    """
    cube(10,10,10);
    """
    Then Guard should notify you with "openscad SUCCESS"
    And a file named "scad/cube.csg" should exist

