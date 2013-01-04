class Invitation < ActiveRecord::Base
  
  belongs_to :ballot_box
  
  after_validation :set_code
  
  after_save :send_email
  
  attr_accessor :email_address
  
  private
  
  def send_email
    ConsensusMailer.invitation(
      :email_address => self.email_address, 
      :motion => self.ballot_box.name,
      :invite_code => self.code
    ).deliver
  end
    
  def set_code
    self.code = Invitation.generate_code
  end
  
  def self.generate_code
    Array.new(6) { (rand(122-97) + 97).chr }.join
  end
end
