require File.dirname(File.expand_path(__FILE__))+'/helper'

class TestXmlCanonicalizer < Test::Unit::TestCase
  
  should "canonicalize a simple xml file" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    xml = "<foo bar='test'/>"
    rexml = REXML::Document.new(xml)
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml)
    
    xml_expect = "<foo bar=\"test\"></foo>"
    assert_equal xml_expect, xml_canonicalized
  end
  
  should "canonicalize a complex xml file" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml = rexml_fixture("complex.xml")
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml)
    
    xml_expect = fixture("expected.xml")
    assert_equal xml_expect, xml_canonicalized
  end
  
  should "canonicalize an xml element correctly" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml = rexml_fixture("complex.xml")
    element = REXML::XPath.first(rexml, "//AttributeValue[@FriendlyName='type']")
    element_canonicalized = xml_canonicalizer.canonicalize(element)
    
    element_expected = '<AttributeValue FriendlyName="type" type="example:profile:attribute">Person</AttributeValue>'
    assert_equal element_expected, element_canonicalized
  end
  
  should "canonicalize a saml xml file correctly" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(false,true)
    
    rexml = rexml_fixture("saml_assertion.xml")
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml)
    
    xml_expect = fixture("saml_expected_canonical_form.xml")
    assert_equal xml_expect, xml_canonicalized
  end
  
  should "canonicalize a saml file with inclusive namespaces" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(false,true)
    
    rexml = rexml_fixture("saml_with_inclusive_ns_assertion.xml")
    xml_canonicalizer.inclusive_namespaces = %w(ds saml samlp xs)
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml)
    
    xml_expect = fixture("saml_with_inclusive_ns_expected_canonical_form.xml")
    assert_equal xml_expect, xml_canonicalized #, (xml_canonicalized.to_s + "\n\n" + xml_expect)
  end

end
