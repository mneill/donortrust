require 'pdf/writer'
require 'action_view/helpers/number_helper'
include ActionView::Helpers::NumberHelper

module PDFFactory
  def create_gift_pdf(gift)
      _pdf = PDF::Writer.new
      _pdf.select_font "Times-Roman"
      _pdf.compressed=true
      image_path = File.expand_path("#{RAILS_ROOT}/public#{gift.ecard.sub(/\/large\//, '/printable/')}")
      i0 = _pdf.image image_path if File.exists?(image_path)
      # make sure to add text on top of the image! 
      #_pdf.add_text_wrap(85, 145, 500, gift[:pickup_code], 12, :justification=>:right)
      _pdf.add_text(138, 151, gift[:pickup_code], 12)
      return _pdf
  end


  
  def create_tax_receipt_pdf(receipt, duplicate=true)
    _pdf = PDF::Writer.new
    _pdf.select_font "Times-Roman"
    _pdf.compressed=true
    i0 = nil
    if duplicate
      i0 = _pdf.image File.dirname(__FILE__) + "/tax_receipt-duplicate.png"
    else
      i0 = _pdf.image File.dirname(__FILE__) + "/tax_receipt.png"
    end
    x = 227
    font_size = 8
    _pdf.add_text(x+14, 639, receipt.id_display, font_size)
    _pdf.add_text(x, 625, number_to_currency(receipt.investment.amount), font_size)
    _pdf.add_text(x, 612, receipt.created_at.to_s(), font_size)
    _pdf.add_text(x, 598, receipt.investment.created_at.to_s(), font_size)
    x2 = 187
    _pdf.add_text(x2, 565, receipt[:first_name] + ' ' + receipt[:last_name], font_size)
    _pdf.add_text(x2, 549, receipt.address, font_size)
    _pdf.add_text(x2, 533, receipt.city, font_size)
    x3 = 367
    _pdf.add_text(x3, 533, receipt.province, font_size)
    _pdf.add_text(x2, 517, receipt.postal_code, font_size)
    _pdf.add_text(x3, 517, receipt.country, font_size)
    return _pdf
  end
end