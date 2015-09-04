require 'active_record'
require 'pry'
require 'mbox'

  # attr_accessor :mime_version, :received, :date, :subject, :from, :to, :gmail_labels, :delivered_to, :message_id, :content_text, :content_html

### REGEX ###
# labels = {regex: ?????, value: 'gmail_labels'}
MIME_version = { regex: /MIME-Version:\s(.+)/, value: 'mime_version'}
received = { regex: /Received:\sby\s([\d|\.]+).*;\s(.+)/, value: 'received'}
date = {regex: /Date:\s(.+)/, value: 'date'}
# delivered_to = {regex: ?????, value: 'delivered_to'}
# message_id = {regex: ?????, value: 'message_id'}
subject = {regex: /Subject:\s(.+)/, value: 'subject'}
from = {regex: /From:\s(.+)\s<(.*@.*\..*)>/, value: 'from'}
to = {regex: /To:\s(.+)\s<(.*@.*\..*)>/,  value:'to' }
# message_plain = {regex: ?????, value: 'content_plain'} # currently undefined
# message_html = {regex: ?????, value: 'content_html'} # currently undefined
re_start = /X-GM-THRID:\s(.+)/ 
re_boundary = /--(.+)--/ # Easy way to see where file ends, need to be smarter and use hash

attributes = [MIME_version, received, date, subject, from, to] # add the others later... re_message_plain, re_message_html, etc.


message = Message.create
messages = []

def parse_mbox_file file
  File.foreach(file) do |line|
    if re_boundary.match(line)
      messages << message
      return
    end

    attributes.each do |attribute|
      found_attribute = attribute[:regex].match(line) 
      if found_attribute
        message.update("#{attribute[:value]}": found_attribute) #do we need to call .strip anywhere here? on value? 

        # remove the current attribute from the array so that other lines don't check for that attribute unnecessarily
        attributes - [attribute]
        break
      end
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