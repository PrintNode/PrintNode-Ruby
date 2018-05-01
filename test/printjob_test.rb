require 'test/unit'
require 'base64'
require 'printnode'

class PrintJobTest < Test::Unit::TestCase


  def test_creating_pdf_uri_printjob
    printjob = PrintNode::PrintJob.new(
      12345,
      "test title",
      "pdf_uri",
      "https://a_pdf.pdf",
      "PrintNode-Ruby")

    assert_equal(
      {
        'printerId' => 12345,
        'title' => 'test title',
        'contentType' => 'pdf_uri',
        'content' => 'https://a_pdf.pdf',
        'source' => 'PrintNode-Ruby'
      },
      printjob.to_hash)
  end

  def test_creating_base64_printjob
    content = Base64.encode64(IO.read("test.pdf"))
    printjob = PrintNode::PrintJob.new(
      12345,
      "test title",
      "pdf_base64",
      content,
      "PrintNode-Ruby")

    assert_equal(
      {
        'printerId' => 12345,
        'title' => 'test title',
        'contentType' => 'pdf_base64',
        'content' => content,
        'source' => 'PrintNode-Ruby'
      },
      printjob.to_hash)
  end

  def test_creating_base64_file_printjob
    content = Base64.encode64(IO.read("test.pdf"))
    printjob = PrintNode::PrintJob.new(
      12345,
      "test title",
      "pdf_base64",
      "test.pdf",
      "PrintNode-Ruby")

    assert_equal(
      {
        'printerId' => 12345,
        'title' => 'test title',
        'contentType' => 'pdf_base64',
        'content' => content,
        'source' => 'PrintNode-Ruby'
      },
      printjob.to_hash)
  end
end
