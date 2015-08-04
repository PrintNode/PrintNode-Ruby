require 'test/unit'
require 'printnode'

class Computers_Test < Test::Unit::TestCase
  def setup
    @auth = PrintNode::Auth.new("MyAuth")
    @client = PrintNode::Client.new(@auth)
    @client.get("/test/data/generate")
  end

  def teardown
    @client = PrintNode::Client.new(@auth)
    @client.delete("/test/data/generate")
  end

  def test_computers
    computers = @client.computers
    assert_instance_of(Fixnum,computers[0].id,"computers[0].id was not instance of Fixnum")
  end

  def test_printers
    printers = @client.printers
    assert_instance_of(Fixnum,printers[0].computer.id,"printers[0].computer.id was not instance of Fixnum")
  end

  def test_printjobs
    printjobs = @client.printjobs
    assert_instance_of(Fixnum,printjobs[0].printer.computer.id,"printjobs[0].printer.computer.id was not instance of Fixnum")
  end

  def test_printing_combination
    a_computer = @client.computers[0]
    a_printer = @client.printers(a_computer.id.to_s,"")[0]
    a_printjob = @client.printjobs(a_printer.id.to_s,"")[0]
    assert_equal(a_computer.id,a_printjob.printer.computer.id,"a_printjob.printer.computer.id was not equal to a_computer.id")
  end

  def test_states
    states = @client.states
    assert_instance_of(String,states[0][0].state,"states[0][0].state was not a string.")
  end

  def test_create_printjob
    a_printer_id = @client.printers[0].id
    options = {}
    options["options"] = {"bin" => "1"}
    options["qty"] = 1
    my_printjob_info = PrintNode::PrintJob.new(a_printer_id,"PrintNode-Ruby Print","pdf_uri","https://a_pdf.pdf","PrintNode-Ruby")
    created_printjob = @client.create_printjob(my_printjob_info,options)
    assert_instance_of(Fixnum,created_printjob,"created_printjob did not return a Fixnum..")
  end

  def test_scales
    my_scales = @client.scales(0)
    a_scale = my_scales[0]
    assert_instance_of(Fixnum,a_scale.measurement.g,"Scale did not have measurements for grams.")
  end
end
