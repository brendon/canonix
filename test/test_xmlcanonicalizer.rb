require File.dirname(File.expand_path(__FILE__))+'/helper'

class TestXmlcanonicalizer < Test::Unit::TestCase
  
  should "canonicalize a simple xml file" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    xml = "<foo bar='test'/>";
    rexml = REXML::Document.new(xml);
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml);
    xml_expect = "<foo bar=\"test\"></foo>";
    assert_equal xml_expect, xml_canonicalized
  end
  
  should "canonicalize a complex xml file" do
    fp = File.new(File.dirname(File.expand_path(__FILE__))+'/complex.xml','r')
    xml = ''
    while (l = fp.gets)
      xml += l
    end
    fp.close
    
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    rexml = REXML::Document.new(xml);
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml);
    
    fp = File.new(File.dirname(File.expand_path(__FILE__))+'/expected.xml','r')
    xml_expect = ''
    while (l = fp.gets)
      xml_expect += l
    end
    fp.close
    
    assert_equal xml_expect, xml_canonicalized
  end

  should "canonicalize a saml xml file correctly" do
    fp = File.new(File.dirname(File.expand_path(__FILE__))+'/saml_assertion.xml','r')
    xml = ''
    while (l = fp.gets)
      xml += l
    end
    fp.close
    
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(false,true)
    rexml = REXML::Document.new(xml);
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml);
    
    fp = File.new(File.dirname(File.expand_path(__FILE__))+'/saml_expected_canonical_form.xml','r')
    xml_expect = ''
    while (l = fp.gets)
      xml_expect += l
    end
    fp.close
    
    assert_equal xml_expect, xml_canonicalized
  end

end
