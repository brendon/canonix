require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'xmlcanonicalizer'

class Test::Unit::TestCase
end

def fixture_path(name)
  File.join(File.dirname(__FILE__), name)
end

def fixture(name)
  File.read(fixture_path(name))
end

def rexml_fixture(name)
  REXML::Document.new(fixture(name))
end
