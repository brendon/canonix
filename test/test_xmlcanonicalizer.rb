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
  
  should "canonicalize multiple documents" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml_1 = rexml_fixture("complex.xml")
    xml_canonicalizer.canonicalize(rexml_1)
    
    rexml_2 = rexml_fixture("complex.xml")
    xml_canonicalized_2 = xml_canonicalizer.canonicalize(rexml_2)
    
    xml_expect = fixture("expected.xml")
    assert_equal xml_expect, xml_canonicalized_2
  end
  
  should "canonicalize the same document multiple times" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml = rexml_fixture("complex.xml")
    xml_canonicalized_1 = xml_canonicalizer.canonicalize(rexml)
    xml_canonicalized_2 = xml_canonicalizer.canonicalize(rexml)
    
    assert_equal xml_canonicalized_1, xml_canonicalized_2
  end
  
  should "canonicalize an xml element correctly" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml = rexml_fixture("complex.xml")
    element = REXML::XPath.first(rexml, "//AttributeValue[@FriendlyName='type']")
    element_canonicalized = xml_canonicalizer.canonicalize(element)
    
    element_expected = '<AttributeValue FriendlyName="type" type="example:profile:attribute">Person</AttributeValue>'
    assert_equal element_expected, element_canonicalized
  end
  
  should "canonicalize the same element multiple times" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml = rexml_fixture("complex.xml")
    element = REXML::XPath.first(rexml, "//AttributeValue[@FriendlyName='type']")
    element_canonicalized_1 = xml_canonicalizer.canonicalize(element)
    element_canonicalized_2 = xml_canonicalizer.canonicalize(element)
    
    assert_equal element_canonicalized_1, element_canonicalized_2
  end
  
  should "canonicalize multiple xml elements correctly" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(true,true)
    
    rexml = rexml_fixture("complex.xml")
    
    element_1 = REXML::XPath.first(rexml, "//AttributeValue[@FriendlyName='type']")
    xml_canonicalizer.canonicalize(element_1)
    
    element_2 = REXML::XPath.first(rexml, "//AuthnStatement")
    element_2_canonicalized = xml_canonicalizer.canonicalize(element_2)
    element_2_expected = '<AuthnStatement AuthnInstant="2010-09-10T00:00:50-05:00"><AuthnContext><AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:PreviousSession</AuthnContextClassRef></AuthnContext></AuthnStatement>'
    assert_equal element_2_expected, element_2_canonicalized
  end
  
  should "canonicalize a saml xml file correctly" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(false,true)
    
    rexml = rexml_fixture("saml_assertion.xml")
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml)
    
    xml_expect = fixture("saml_expected_canonical_form.xml")
    assert_equal xml_expect, xml_canonicalized
  end

  should "canonicalize a saml xml file with default namespace correctly" do
    xml_canonicalizer = XML::Util::XmlCanonicalizer.new(false,true)
    
    rexml = rexml_fixture("saml_with_default_namespace.xml")
    xml_canonicalized = xml_canonicalizer.canonicalize(rexml)
    
    xml_expect = fixture("saml_with_default_namespace_expected_canonical_form.xml")
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
