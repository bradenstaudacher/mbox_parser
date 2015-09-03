require 'active_record'
require 'pry'
require 'mbox'
### REGEX ###
# re_labels
# re_MIME_version = /MIME-Version:\s(.+)/
# re_received = /Received:\sby\s([\d|\.]+).*;\s(.+)/
# re_date = /Date:\s(.+)/
# re_delivered_to
# re_message_id
# re_subject = /Subject:\s(.+)/
# re_from = /From:\s(.+)\s<(.*@.*\..*)>/
# re_to = /To:\s(.+)\s<(.*@.*\..*)>/
# re_message_plain # currently undefined
# re_message_html # currently undefined
# re_start = /X-GM-THRID:\s(.+)/
re_boundary = /--(.+)--/ # Easy way to see where file ends, need to be smarter and use hash

message = [] # Message accumulator
messages = []

File.foreach('test.mbox') do |line|
  message << line.strip
  if re_boundary.match(line)
    # puts "BEHOLD A MESSAGE"
     messages << message
    # puts "END OF MESSAGE"
    message = []
  end
end

# class Message < ActiveRecord::Base
#   attr_accessor :mime_version, :received, :date, :subject, :from, :to
#   validates :mime_version, presence: true
#   validates :received, presence: true
#   validates :date, presence: true
#   validates :subject, presence: true
#   validates :from, presence: true
#   validates :to, presence: true
# end