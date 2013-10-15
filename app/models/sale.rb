class Sale < ActiveRecord::Base
  attr_accessor :file
  validates :cash, :numericality => true, :presence => true
  validates :file, :presence => true
  before_save :read_from_file
  
  def net_value
    if self.value && self.vat
      return self.value - self.vat
    else
      return ""
    end
  end
  
  private
  
  def read_from_file ()
    # Sets files_content
    File.open(Rails.root.join('tmp', self.file.original_filename), 'r' ) do |file|
      self.file_content = file.read.encode("UTF-8", invalid: :replace, undef: :replace)
    end
    
    # Converts file_content to array of lines
    lines = self.file_content.lines
    logger.debug "Lines: #{lines}"
    
    # Reads report date from line no 10
    self.date = lines[9][33..42].split('-').reverse.join('-')
    
    # Reads report number from line no 11
    self.number = lines[10].match('\d+')[0]
    
    # TODO: Finds pos_id by unique register number
    register_number = lines[6].chop[-11..-1]
    #self.pos_id = Pos.find_by_register_number(register_number).id
    logger.debug "Register number: |#{register_number}|"
    
    # Finds position of daily fiscal report header
    summary_line_no = lines.index do |string|
      string.chop == '.  R A P O R T   F I S K A L N Y   D O B O W Y   '
    end
    logger.debug "Report header line: |#{summary_line_no}|"
    
    # Finds vat value
    self.vat = lines[summary_line_no + 18].match('\d+\.?\d*')[0]
    
    # Finds total value
    self.value = lines[summary_line_no + 20].match('\d+\.?\d*')[0]
    
  end
  
end
