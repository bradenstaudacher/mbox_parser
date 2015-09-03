require 'active_record'
require 'pry'
require 'mbox'

  # attr_accessor :mime_version, :received, :date, :subject, :from, :to, :gmail_labels, :delivered_to, :message_id, :content_text, :content_html

### REGEX ###
# labels = AttributeSeeker.new(?????, 'gmail_labels')
MIME_version = AttributeSeeker.new(/MIME-Version:\s(.+)/, 'mime_version')
received = AttributeSeeker.new(/Received:\sby\s([\d|\.]+).*;\s(.+)/, 'received')
date = AttributeSeeker.new(/Date:\s(.+)/, 'date')
# delivered_to = AttributeSeeker.new(?????, 'delivered_to')
# message_id = AttributeSeeker.new(?????, 'message_id')
subject = AttributeSeeker.new(/Subject:\s(.+)/, 'subject')
from = AttributeSeeker.new(/From:\s(.+)\s<(.*@.*\..*)>/, 'from')
to = AttributeSeeker.new(/To:\s(.+)\s<(.*@.*\..*)>/, 'to' )
# message_plain = Attribute_seeker.new(?????, 'content_plain') # currently undefined
# message_html = Attribute_seeker.new(?????, 'content_html') # currently undefined
re_start = /X-GM-THRID:\s(.+)/ 
re_boundary = /--(.+)--/ # Easy way to see where file ends, need to be smarter and use hash

attribute_seekers = [MIME_version, received, date, subject, from, to] # add the others later... re_message_plain, re_message_html, etc.


#  A simple object that simply associates a regex which returns a specific value, to its corresponding active record attribute name on the Message object.  Trying to think of name...  'AttributeSeeker' maybe... 
class AttributeSeeker
  attr_accessor :regex, :ar_attr

  def initialize regex, ar_attr
    @regex = regex
    @ar_attr = ar_attr
  end  
end

message = Message.new
messages = []
entire_message_string = []
message_strings = []

def parse_mbox_file file
  File.foreach(file) do |line|
    attribute_seekers.each do |attribute_seeker|
      value = attribute_seeker.regex.match(line) 
      if value
        message.update("#{attribute_seeker.ar_attr}": value)
      end
    end

    entire_message_string << line.strip
    if re_boundary.match(line)
      puts "BEHOLD A MESSAGE"
      message.save
      message_strings << entire_message_string
      messages << message
      puts "END OF MESSAGE"
      entire_message_string = []
    end
  end
end

parse_mbox_file('test.mbox')



class Message < ActiveRecord::Base
  attr_accessor :mime_version, :received, :date, :subject, :from, :to, :gmail_labels, :delivered_to, :message_id, :content_text, :content_html

  validates :mime_version, presence: true
  validates :received, presence: true
  validates :date, presence: true
  validates :subject, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :gmail_labels, presence: true
  validates :delivered_to, presence: true
  validates :message_id, presence: true
  validates :content_text, presence: true
  validates :content_html, presence: true
end